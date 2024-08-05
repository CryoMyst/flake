{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.personal.shares;
in {
  options.cryo.personal.shares = {
    ram = lib.mkEnableOption "Enable ram share";
    rem = lib.mkEnableOption "Enable rem share";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        # fileSystems = lib.mkMerge [
        #   lib.mkIf
        #   cfg.ram
        #   {
        #     "/mnt/ram" = {
        #       device = "nas.cryo.red:/ram";
        #       fsType = "nfs";
        #       options = "nobootwait";
        #     };
        #   }
        #   lib.mkIf
        #   cfg.rem
        #   {
        #     "/mnt/rem" = {
        #       device = "nas.cryo.red:/rem";
        #       fsType = "nfs";
        #       options = "nobootwait";
        #     };
        #   }
        # ];
      };
    };
  };
}
