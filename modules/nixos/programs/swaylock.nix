{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.swaylock;
in {
  options.cryo.programs.swaylock = {
    enable = lib.mkEnableOption "Enable swaylock module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        security = {
          pam = {
            services = {
              swaylock = {
                text = ''
                  auth include login
                '';
              };
            };
          };
        };
      };
      home-manager.config = {
        home = {
          packages = with pkgs; [
            swaylock
          ];
        };

        programs = {
          swaylock = {
            enable = true;
            settings = {
              color = "#000000";
              show-failed-attempts = true;
            };
          };
        };
      };
    };
  };
}
