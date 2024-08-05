{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.setups.terminal;
in {
  options.cryo.setups.terminal = {
    enable = lib.mkEnableOption "Enable  module";
  };

  config = lib.mkIf cfg.enable {
    cryo = {
      programs = {
        direnv.enable = true;
        tmux.enable = true;
        nvim.enable = true;
        zsh.enable = true;
      };
    };

    cryo.core = {
      nixos.config = {
        documentation.dev.enable = true;
        programs.ssh.startAgent = true;
      };
      home-manager.config = {
        home = {
          packages = with pkgs; [
            git
            htop
            btop
            unzip
            p7zip
            hdparm
            wget
            jq
            lazygit
            lazydocker
            zoxide
            pciutils
            valgrind
            distrobox
            screen
            man-pages
            man-pages-posix
            sshed
          ];
        };
      };
    };
  };
}
