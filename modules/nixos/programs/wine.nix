{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.wine;
in {
  options.cryo.programs.wine = {
    enable = lib.mkEnableOption "Enable wine module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = with pkgs; [
            winetricks
            wineWowPackages.stagingFull
          ];
        };
      };
    };
  };
}
