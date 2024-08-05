{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.bluetooth;
in {
  options.cryo.features.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = let
        hostname = config.cryo.core.nixos.hostname;
      in {
        services.blueman.enable = true;
        hardware = {
          enableAllFirmware = true;
          bluetooth = {
            enable = true; # enables support for Bluetooth
            powerOnBoot = true; # powers up the default Bluetooth controller on boot
            package = pkgs.bluez;
            settings = {
              General = {
                Name = hostname;
                ControllerMode = "dual";
                FastConnectable = "true";
                Experimental = "true";
              };
              Policy = {
                AutoEnable = "true";
              };
            };
          };
        };
      };
    };
  };
}
