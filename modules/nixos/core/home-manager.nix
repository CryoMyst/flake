{
  lib,
  pkgs,
  config,
  home-manager,
  flake,
  ...
}: let
  cfg = config.cryo.core.home-manager;
  mergeType = flake.lib.types.merge;
in {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.cryo.core.home-manager = {
    enable = lib.mkEnableOption "Enable home-manager module";
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for home-manager";
    };
    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "State version for home-manager";
    };
    config = lib.mkOption {
      type = mergeType;
      default = {};
      description = "Home-manager configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.username != null;
        message = "cryo: core.home-manager - username is not set";
      }
      {
        assertion = cfg.stateVersion != null;
        message = "cryo: core.home-manager - stateVersion is not set";
      }
    ];

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${cfg.username} = lib.mkMerge [
        {
          home.stateVersion = cfg.stateVersion;
        }
        cfg.config
      ];
    };
  };
}
