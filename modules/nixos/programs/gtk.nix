{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.gtk;
in {
  options.cryo.programs.gtk = {
    enable = lib.mkEnableOption "Enable gtk module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        environment = {
          sessionVariables = {
            GTK_THEME = "Adwaita:dark";
          };
        };
      };
      home-manager.config = {
        home = {
          packages = with pkgs; [
            adwaita-icon-theme
          ];
        };

        gtk = {
          enable = true;
          iconTheme = {
            name = "Adwaita-dark";
            package = pkgs.adwaita-icon-theme;
          };
          theme = {
            name = "Adwaita-dark";
            package = pkgs.adwaita-icon-theme;
          };
        };
      };
    };
  };
}
