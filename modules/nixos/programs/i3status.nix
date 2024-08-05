{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.i3status;
in {
  options.cryo.programs.i3status = {
    enable = lib.mkEnableOption "Enable i3status module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        programs = {
          i3status = {
            enable = true;
            enableDefault = false;

            general = {
              colors = true;
              interval = 5;
            };

            modules = {
              "disk /" = {
                position = 1;
                settings = {format = "%avail";};
              };

              "load" = {
                position = 2;
                settings = {format = "%1min";};
              };

              "memory" = {
                position = 3;
                settings = {
                  format = "%used/%available";
                  threshold_degraded = "1G";
                  format_degraded = "MEMORY < %available";
                };
              };

              "tztime local" = {
                position = 100;
                settings = {format = "%Y-%m-%d %H:%M:%S";};
              };
            };
          };
        };
      };
    };
  };
}
