{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo;
in {
  options.cryo = {
    enable = lib.mkEnableOption "Global enable the cryo module.";
  };

  config = lib.mkIf cfg.enable {
    cryo = {
      core = {
        nixos.enable = true;
        home-manager.enable = true;
      };
      features = {
        user.enable = true;
      };
    };
  };
}
