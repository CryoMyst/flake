{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.network;
in {
  options.cryo.features.network = {
    enable = lib.mkEnableOption "Enable network module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        networking = {
          firewall.enable = true;
          hostName = config.cryo.core.nixos.hostname;
          networkmanager.enable = true;
        };
      };
      nixos.userConfig = {
        extraGroups = [
          "networkmanager"
        ];
      };
    };
  };
}
