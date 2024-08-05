{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.setups.social;
in {
  options.cryo.setups.social = {
    enable = lib.mkEnableOption "Enable social module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages =
            (lib.optionals true [
              pkgs.telegram-desktop
            ])
            ++ (lib.optionals (pkgs.system == "x86_64-linux") [
              pkgs.teamspeak_client
              pkgs.discord
            ]);
        };
      };
    };
  };
}
