{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.SECTION.CHANGEME;
in {
  options.cryo.SECTION.CHANGEME = {
    enable = lib.mkEnableOption "TODO";
  };

  config =
    lib.mkIf cfg.enable {
    };
}
