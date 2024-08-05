{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.direnv;
in {
  options.cryo.programs.direnv = {
    enable = lib.mkEnableOption "Enable direnv module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        programs = {
          direnv = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            nix-direnv = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
