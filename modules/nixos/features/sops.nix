{
  lib,
  pkgs,
  config,
  sops-nix,
  ...
}: let
  cfg = config.cryo.features.sops;
in {
  imports = [
    sops-nix.nixosModules.sops
  ];

  options.cryo.features.sops = {
    enable = lib.mkEnableOption "Enable sops module";
    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The age key to use for decryption";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.age.keyFile = cfg.keyFile;
  };
}
