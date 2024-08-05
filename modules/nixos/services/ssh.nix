{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.services.ssh;
in {
  options.cryo.services.ssh = {
    enable = lib.mkEnableOption "Enable ssh module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        services.openssh = {
          enable = true;

          settings = {
            X11Forwarding = true;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };
      };
    };
  };
}
