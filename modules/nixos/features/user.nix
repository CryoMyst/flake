{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.user;
in {
  options.cryo.features.user = {
    enable = lib.mkEnableOption "Enable user module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        users = {
          groups = {
            "flakemanager" = {};
          };
        };
      };
      nixos.userConfig = {
        isNormalUser = true;
        description = "${config.cryo.core.nixos.username}";
        extraGroups = [
          "flakemanager"
          "wheel"
        ];
      };
    };
  };
}
