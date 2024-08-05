{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.graphics;
in {
  options.cryo.features.graphics = {
    enable = lib.mkEnableOption "Enable graphics module";
    gpuTypes = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["nvidia" "amd" "intel" "asahi"]);
      default = [];
      description = "List of GPUs to enable support for";
    };
  };
  config = lib.mkIf cfg.enable {
    cryo.core.nixos.config = lib.mkMerge [
      (lib.optionalAttrs (builtins.elem "nvidia" cfg.gpuTypes) {
        boot.initrd.kernelModules = ["nvidia"];
        services.xserver.videoDrivers = ["nvidia"];
        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
          };
          nvidia = {
            package = pkgs.nvidiaPackages.beta;
          };
        };
      })
      (lib.optionalAttrs (builtins.elem "amd" cfg.gpuTypes) {
        boot.initrd.kernelModules = ["amdgpu"];
        services.xserver.videoDrivers = ["amdgpu"];
        hardware = {
          graphics = {
            enable = true;
            extraPackages = with pkgs; [rocm-opencl-icd rocm-opencl-runtime amdvlk mesa.drivers];
            extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
            enable32Bit = true;
          };
        };
      })
      (lib.optionalAttrs (builtins.elem "asahi" cfg.gpuTypes) {
        asahi = {
          useExperimentalGPUDriver = true;
          #   Mode to use to install the experimental GPU driver into the system.

          #   driver: install only as a driver, do not replace system Mesa.
          #     Causes issues with certain programs like Plasma Wayland.

          #   replace (default): use replaceRuntimeDependencies to replace system Mesa with Asahi Mesa.
          #     Does not work in pure evaluation context (i.e. in flakes by default).

          #   overlay: overlay system Mesa with Asahi Mesa
          #     Requires rebuilding the world.
          experimentalGPUInstallMode = "overlay";
          withRust = true;
        };
        graphics.enable = true;
      })
    ];
  };
}
