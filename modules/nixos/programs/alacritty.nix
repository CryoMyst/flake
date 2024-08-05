{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.alacritty;
in {
  options.cryo.programs.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = with pkgs; [
            alacritty
          ];
        };

        programs.alacritty = {
          enable = true;
          settings = {
            colors = {
              primary = {
                background = "0x000000";
              };
            };
          };
        };
      };
    };
  };
}
