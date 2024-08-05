{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.features.fonts;
in {
  options.cryo.features.fonts = {
    enable = lib.mkEnableOption "Enable fonts module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        fonts = {
          fontconfig.enable = true;
          packages = with pkgs; [
            ubuntu_font_family
            source-code-pro
            proggyfonts
            powerline-fonts
            noto-fonts-emoji
            noto-fonts-cjk
            noto-fonts
            nerdfonts
            mplus-outline-fonts.githubRelease
            liberation_ttf
            kanji-stroke-order-font
            jetbrains-mono
            ipafont
            font-awesome
            # emojione
            dina-font
            corefonts
          ];
        };
      };
    };
  };
}
