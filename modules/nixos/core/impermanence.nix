{
  lib,
  pkgs,
  config,
  impermanence,
  ...
}: let
  cfg = config.cryo.core.impermanence;
  mergeType = impermanence.lib.types.merge;
in {
  imports = [
    impermanence.nixosModules.impermanence
  ];

  options.cryo.core.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence module";
    root = {
      enable = lib.mkEnableOption "Enable impermanence for root";
      config = lib.mkOption {
        type = mergeType;
        default = {};
        description = "impermanence configuration for root";
      };
    };
    home = {
      enable = lib.mkEnableOption "Enable impermanence for home";
      config = lib.mkOption {
        type = mergeType;
        default = {};
        description = "impermanence configuration for home";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        programs.fuse.userAllowOther = true;
      };
    };
  };
}
