{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.services.xserver;
in {
  options.cryo.services.xserver = {
    enable = lib.mkEnableOption "Enable xserver module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        services = {
          xserver = {
            enable = true;
            enableTCP = true;
            exportConfiguration = true;
            logFile = "/var/log/Xorg.0.log";
            # verbose = 7;
          };

          libinput.enable = true;
        };
      };
      home-manager.config = {
        home = {
          # Utility packages
          packages = with pkgs; [
            xorg.xhost
            xorg.xkill
          ];
        };
      };
    };
  };
}
