{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.lutris;
in {
  options.cryo.programs.lutris = {
    enable = lib.mkEnableOption "Enable lutris module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = with pkgs; [
            (lutris.override {
              extraPkgs = pkgs: [
                winetricks
                wineWowPackages.staging
                libnghttp2
                jansson
              ];
            })
          ];
        };
      };
    };
  };
}
