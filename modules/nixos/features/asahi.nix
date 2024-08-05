{
  lib,
  pkgs,
  config,
  nixos-apple-silicon,
  ...
}: let
  cfg = config.cryo.features.asahi;
in {
  imports = [
    nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  options.cryo.features.asahi = {
    enable = lib.mkEnableOption "Enable asahi module";
    peripheralFirmwareDirectory = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Location of M1 peripheral firmware";
    };
  };

  config = {
    assertions = [
      {
        assertion =
          if cfg.enable
          then (cfg.peripheralFirmwareDirectory != null)
          else true;
        message = "cryo: features.asahi - Peripheral firmware directory must be set";
      }
    ];

    hardware.asahi.enable = cfg.enable;

    cryo.features.graphics = lib.mkIf cfg.enable {
      enable = true;
      gpuTypes = ["asahi"];
    };

    cryo.core = lib.mkIf cfg.enable {
      nixos.config = {
        boot = {
          # We do not control the EFI partition on Asahi
          loader.efi.canTouchEfiVariables = false;
          ardware.asahi.peripheralFirmwareDirectory = cfg.peripheralFirmwareDirectory;
        };
      };
    };
  };
}
