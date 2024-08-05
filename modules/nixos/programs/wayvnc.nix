{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.wayvnc;
in {
  options.cryo.programs.wayvnc = {
    enable = lib.mkEnableOption "Enable wayvnc module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = with pkgs; [
            wayvnc
          ];
        };

        xdg.configFile.wayvnc = {
          text = ''
            use_relative_paths=true
            address=127.0.0.1
            enable_auth=false
          '';
          recursive = true;
        };
      };
    };
  };
}
