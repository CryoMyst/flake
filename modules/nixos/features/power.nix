{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.power;
in {
  options.cryo.features.power = {
    enable = lib.mkEnableOption "Enable power module";
    disablePowerButton = lib.mkEnableOption "Disable power button";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        services.logind.extraConfig =
          if cfg.disablePowerButton
          then ''
            # don’t shutdown when power button is short-pressed
            HandlePowerKey=ignore
          ''
          else '''';
      };
    };
  };
}
