{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.boot;
in {
  options.cryo.features.boot = {
    enable = lib.mkEnableOption "Enable boot module";
    kernelParams = {
      appleShowNotch = lib.mkOption {
        # https://wiki.archlinux.org/title/Apple_Keyboard
        # show_notches - Show notches on the touchbar
        #     0 - disabled
        #     1 - enabled
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Show notches on the touchbar";
      };
      appleFnMode = lib.mkOption {
        # https://wiki.archlinux.org/title/Apple_Keyboard
        # fnmode - Mode of top-row keys
        #     0 - disabled
        #     1 - normally media keys, switchable to function keys by holding Fn key (=auto on Apple keyboards)
        #     2 - normally function keys, switchable to media keys by holding Fn key (=auto on non-Apple keyboards)
        #     3 - auto (Default)
        type = lib.types.nullOr lib.types.enum ["disabled" "media" "function" "auto"];
        default = null;
        description = "Set the mode of the top-row keys on Apple keyboards";
      };
    };
    kernelPatches = {
      overrideAmdGpuMinPowerCap = lib.mkEnableOption "Override AMD GPU minimum power cap";
    };
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        boot = {
          loader = {
            systemd-boot = {
              enable = true;
              editor = false;
              configurationLimit = 20;
              consoleMode = lib.mkDefault "auto";
              memtest86.enable = true;
            };
            efi.canTouchEfiVariables = lib.mkDefault true;
          };
          tmp.cleanOnBoot = true;
          kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
          kernelParams = [];
          kernelPatches = lib.optionals cfg.kernelPatches.overrideAmdGpuMinPowerCap [
            {
              name = "amdgpu-power";
              patch = ./kernel/patches/amdgpu-power.patch;
            }
          ];
        };
      };
    };
  };
}
