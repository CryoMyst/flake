{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.personal.ssh;

  cryomyst-pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBcDtmczDm58vyrc+DkOnu9HzgSaZR7nwOjfK7nGx1Y CryoMyst@hotmail.com";
in {
  options.cryo.personal.ssh = {
    cryomyst = lib.mkEnableOption "Add Cryomyst's public keys to authorized_keys";
  };

  config = lib.mkIf cfg.cryomyst {
    cryo.core = {
      nixos.userConfig = {
        openssh.authorizedKeys.keys = [
          cryomyst-pub
        ];
      };
    };
  };
}
