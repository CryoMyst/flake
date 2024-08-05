{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.services.docker;
in {
  options.cryo.services.docker = {
    enable = lib.mkEnableOption "Enable docker module";
    nvidia = lib.mkEnableOption "Enable nvidia support";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        virtualisation = {
          docker = {
            enable = true;
            enableNvidia = cfg.nvidia;
            logDriver = "json-file";
          };
        };
      };
      nixos.userConfig = {
        extraGroups = ["docker"];
      };
    };
  };
}
