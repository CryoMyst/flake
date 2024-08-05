{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.qt;
in {
  options.cryo.programs.qt = {
    enable = lib.mkEnableOption "Enable qt module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = with pkgs; [
            adwaita-qt
            adwaita-qt6
            qt5.qtwayland
            qt6.qtwayland
          ];
        };
        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = "adwaita-dark";
        };
      };
    };
  };
}
