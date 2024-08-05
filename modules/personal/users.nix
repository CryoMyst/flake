{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.personal.users;
in {
  options.cryo.personal.users = {
    cryomyst = lib.mkEnableOption "Add cryomyst user ";
  };

  config = lib.mkIf cfg.cryomyst {
    sops.secrets.cryomyst_password_hash = {
      sopsFile = ./users/cryomyst.sops.yaml;
      neededForUsers = true;
    };

    users.users.${config.cryo.core.nixos.username}.hashedPasswordFile = config.sops.secrets.cryomyst_password_hash.path;
    cryo.core = {
      nixos = {
        username = "cryomyst";
      };

      home-manager = {
        username = "cryomyst";
      };
    };
  };
}
