{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.yubikey;
in {
  options.cryo.features.yubikey = {
    enable = lib.mkEnableOption "Enable yubikey module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        services.udev.packages = [pkgs.yubikey-personalization];

        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        services.pcscd.enable = true;
      };
    };
  };
}
