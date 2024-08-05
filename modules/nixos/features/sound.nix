{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.sound;
in {
  options.cryo.features.sound = {
    enable = lib.mkEnableOption "Enable sound module";
  };

  config = {
    hardware.pulseaudio.enable = lib.mkForce false;

    cryo.core = lib.mkIf cfg.enable {
      nixos.config = {
        security.rtkit.enable = true;

        # This can cause issues with asahi, let's just always disable it

        services = {
          pipewire = {
            enable = lib.mkDefault true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
          };
        };
      };
      home-manager.config = {
        home = {
          packages = [
            pkgs.pavucontrol
          ];
        };
      };
    };
  };
}
