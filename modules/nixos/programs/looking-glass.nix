{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.looking-glass;
in {
  options.cryo.programs.looking-glass = {
    enable = lib.mkEnableOption "Enable looking-glass module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        systemd.tmpfiles.rules = [
          "f /dev/shm/looking-glass 0660 ${config.cryo.core.nixos.username} kvm -"
        ];
      };
      home-manager.config = {
        home = {
          packages = with pkgs; [
            looking-glass-client
          ];
        };
      };
    };
  };
}
