{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.virtualisation;
in {
  options.cryo.features.virtualisation = {
    enable = lib.mkEnableOption "Enable virtualisation module";
    cpu = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["intel" "amd" "apple"]);
      default = null;
      description = "The CPU type of the host";
    };
    vfioDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "A list of PCI devices bind to the vfio-pci driver";
    };
    hostCpus = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "The number of CPUs on the host";
    };
    virtualMachines = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = null;
            description = "The name of the virtual machine (TMP as I cannot parse it properly)";
          };
          xml = lib.mkOption {
            type = lib.types.pathInStore;
            default = null;
            description = "The XML configuration of the virtual machine";
          };
          config = lib.mkOption {
            type = lib.types.submodule {
              options = {
                pinnedCpus = lib.mkOption {
                  type = lib.types.listOf lib.types.int;
                  default = [];
                  description = "The number of CPUs to pin to the virtual machine";
                };
              };
            };
            default = {};
            description = "extra configuration of the virtual machine";
          };
        };
      });
      default = [];
      description = "Virtual machines defined in the configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      # Ensure all vm files have a name
      {
        assertion = lib.all (vm: vm.xml != null) cfg.virtualMachines;
        message = "cryo: features.virtualisation - All virtual machines must have a xml config";
      }
    ];

    cryo.core = {
      nixos.config = {
        # Not sure if this is needed
        hardware.graphics.enable = true;

        boot = let
          vfioDevices-kernel-param = "vfio-pci.ids=" + lib.concatStringsSep "," cfg.vfioDevices;
        in {
          initrd.kernelModules = [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
          ];

          kernelParams =
            if cfg.cpu == "intel"
            then ["intel_iommu=on" vfioDevices-kernel-param]
            else if cfg.cpu == "amd"
            then ["amd_iommu=on" vfioDevices-kernel-param]
            else
              # Not sure if any flags are required for M1
              [];
        };

        virtualisation = {
          spiceUSBRedirection.enable = true;
          libvirtd = {
            enable = true;
            qemu = {
              swtpm.enable = true;
              ovmf = {
                enable = true;
                packages = [pkgs.OVMFFull.fd];
              };
            };
          };
        };

        virtualisation.libvirtd.hooks.qemu = let
          mkPinCpuLines = let
            listCpus = cpus: lib.concatStringsSep "," (builtins.map (i: "${toString i}") cpus);
            otherCpus = cpus: lib.subtractLists cpus (lib.range 0 (cfg.hostCpus - 1));
            listOtherCpus = cpus: listCpus (otherCpus cpus);
          in
            cpus: ''
              systemctl set-property --runtime -- user.slice AllowedCPUs=${listOtherCpus cpus}
              systemctl set-property --runtime -- system.slice AllowedCPUs=${listOtherCpus cpus}
              systemctl set-property --runtime -- init.scope AllowedCPUs=${listOtherCpus cpus}
            '';
          mkUnpinCpuLines = ''
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-${toString (cfg.hostCpus - 1)}
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-${toString (cfg.hostCpus - 1)}
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-${toString (cfg.hostCpus - 1)}
          '';

          mkQemuHook = virtualMachineName: pinnedCpus: (
            lib.getExe (
              pkgs.writeShellApplication {
                name = "qemu-hook-${virtualMachineName}";

                runtimeInputs = [
                  pkgs.libvirt
                  pkgs.systemd
                  pkgs.kmod
                ];

                text = ''
                  GUEST_NAME="$1"
                  OPERATION="$2"

                  if [ "$GUEST_NAME" != "${virtualMachineName}" ]; then
                    exit 0
                  fi

                  if [ "$OPERATION" == "prepare" ]; then
                    ${lib.optionalString (lib.length pinnedCpus > 0) (mkPinCpuLines pinnedCpus)}
                  fi

                  if [ "$OPERATION" == "release" ]; then
                    ${lib.optionalString (lib.length pinnedCpus > 0) mkUnpinCpuLines}
                  fi
                '';
              }
            )
          );
        in (builtins.listToAttrs (builtins.map
          (vm: {
            name = "qemu-hook-${vm.name}";
            value = mkQemuHook vm.name (vm.config.pinnedCpus or []);
          })
          cfg.virtualMachines));

        systemd.tmpfiles.rules = builtins.map (vm: "L+ /var/lib/libvirt/qemu/${vm.name}.xml - - - - ${vm.xml}") cfg.virtualMachines;

        programs.virt-manager.enable = true;
        programs.dconf.enable = true;
        services.spice-vdagentd.enable = true;
      };
      nixos.userConfig = {
        extraGroups = [
          "libvirtd"
        ];
      };
    };
  };
}
