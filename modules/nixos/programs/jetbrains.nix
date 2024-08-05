{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.jetbrains;

  commonPlugins = [
    "github-copilot"
    "nixidea"
  ];

  addPluginsToJetBrainsProduct = product: specificPlugins:
    pkgs.jetbrains.plugins.addPlugins product (commonPlugins ++ specificPlugins);

  jetbrainsProducts = with pkgs; [
    # Apply common plugins and specific plugins (if any) to each JetBrains IDE
    (addPluginsToJetBrainsProduct jetbrains.pycharm-professional [])
    (addPluginsToJetBrainsProduct jetbrains.clion [])
    (addPluginsToJetBrainsProduct jetbrains.webstorm [])
    (addPluginsToJetBrainsProduct jetbrains.goland [])
    (addPluginsToJetBrainsProduct jetbrains.idea-ultimate [])
    (addPluginsToJetBrainsProduct jetbrains.datagrip [])
    (addPluginsToJetBrainsProduct jetbrains.rust-rover [])
    (addPluginsToJetBrainsProduct (jetbrains.rider.overrideAttrs (oldAttrs: {
      buildInputs =
        oldAttrs.buildInputs
        ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
          expat
          libxml2
          xz
        ];
    })) [])
  ];
in {
  options.cryo.programs.jetbrains = {
    enable = lib.mkEnableOption "Enable jetbrains module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      home-manager.config = {
        home = {
          packages = jetbrainsProducts;
        };
      };
    };
  };
}
