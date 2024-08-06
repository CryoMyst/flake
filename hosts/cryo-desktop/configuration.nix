{
  lib,
  pkgs,
  config,
  nixos-hardware,
  ...
}: let
  stateVersion = "23.11";
  hostname = "cryo-desktop";

  emulatableSystems = [
    "aarch64-linux" "aarch64_be-linux" "alpha-linux" "armv6l-linux" "armv7l-linux" "i386-linux" "i486-linux" "i586-linux" "i686-linux" "i686-windows" "loongarch64-linux" "mips-linux" "mips64-linux" "mips64-linuxabin32" "mips64el-linux" "mips64el-linuxabin32" "mipsel-linux" "powerpc-linux" "powerpc64-linux" "powerpc64le-linux" "riscv32-linux" "riscv64-linux" "sparc-linux" "sparc64-linux" "wasm32-wasi" "wasm64-wasi" "x86_64-linux" "x86_64-windows"
  ];
  emulateSystems = lib.remove "x86_64-linux" emulatableSystems;
in {
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-zenpower
    nixos-hardware.nixosModules.common-gpu-amd
    ./hardware-configuration.nix
  ];

  # nixpkgs.hostPlatform = {
  #   gcc.arch = "znver3";
  #   gcc.tune = "znver3";
  #   system = "x86_64-linux";
  # };

  # boot.binfmt.emulatedSystems = emulateSystems;
  # nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  nix.settings.system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "gccarch-znver3" ];
  swapDevices = [ { device = "/swap/swapfile"; } ];

  cryo = {
    enable = true;
    core = {
      home-manager = {
        stateVersion = stateVersion;
      };
      impermanence = {
        enable = false;
      };
      nixos = {
        hostname = hostname;
        stateVersion = stateVersion;
      };
    };
    setups = {
      sway.enable = true;
    };
    features = {
      # boot.kernelPatches.overrideAmdGpuMinPowerCap = true;
      graphics.gpuTypes = ["amd"];
      sops = {
        enable = true;
        keyFile = "/secrets/nix-sops/key.txt";
      };
      virtualisation = let
        gpuIds = [
          "1002:73ff" # Graphics
          "1002:ab28" # Audio
        ];
      in {
        enable = true;
        cpu = "amd";
        vfioDevices = gpuIds;
        # hostCpus = 24;
        hostCpus = 12;

        virtualMachines = [
          {
            name = "Windows";
            xml = ./Windows.xml;
            config = {
              # pinnedCpus = (lib.range 0 8) ++ (lib.range 16 23);
              pinnedCpus = (lib.range 3 5) ++ (lib.range 9 11);
            };
          }
        ];
      };
    };
    programs = {
      looking-glass.enable = true;
    };
    personal = {
      users.cryomyst = true;
    };
    services = {
      # swayidle.enable = lib.mkForce false;
    };
  };

  services.flatpak.enable = true;

  # Move outside
  boot.kernelParams = [
    "zswap.enabled=1"
    # "amd_pstate=active"
    "amd_iommu=on"
    "mitigations=off"
    # "panic=1"
    # "nowatchdog"
    # "nmi_watchdog=0"
    # "quiet"
    "rd.systemd.show_status=auto"
    "rd.udev.log_priority=3"
    # "rcu_nocbs=0-23"
    # "processor.max_cstate=5"
    # "pci=nomsi"
  ];

  home-manager.users = {
    cryomyst = {
      home = {
        packages = with pkgs;
          [
            obs-studio
            bottles
          ]
          ++ [
          ];
      };
      wayland = {
        windowManager = {
          sway = {
            config = rec {
              startup = [
                {
                  command = ''
                    xrandr --verbose --output "HDMI-A-1" --primary
                  '';
                  always = true;
                }
              ];

              keybindings = let
                # Just redefine here for now
                modifier = "Mod4";
              in
                pkgs.lib.mkOptionDefault {
                  # 10th workspace for 2nd display
                  "${modifier}+0" = "workspace number 10";
                  "${modifier}+Shift+0" = "move container to workspace number 10";
                };

              output = {
                "HDMI-A-1" = {
                  mode = "3840x2160@120.000Hz";
                  pos = "0,0";
                };
                "DP-1" = {
                  mode = "1920x1080@60.000Hz";
                  pos = "3840,0";
                  transform = "270";
                  # transform = "90";
                };
              };

              workspaceOutputAssign = [
                {
                  output = "HDMI-A-1";
                  workspace = "1";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "2";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "3";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "4";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "5";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "6";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "7";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "8";
                }
                {
                  output = "HDMI-A-1";
                  workspace = "9";
                }
                {
                  output = "DP-1";
                  workspace = "10";
                }
              ];
            };
          };
        };
      };
    };
  };
}
