{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.setups.sway;
in {
  options.cryo.setups.sway = {
    enable = lib.mkEnableOption "Enable sway module";
  };

  config = lib.mkIf cfg.enable {
    cryo = {
      programs = {
        alacritty.enable = true;
        gtk.enable = true;
        i3status.enable = true;
        jetbrains.enable = true;
        lutris.enable = true;
        qt.enable = true;
        sway.enable = true;
        swaylock.enable = true;
        wayvnc.enable = true;
        wine.enable = true;
      };
      features = {
        boot.enable = true;
        graphics.enable = true;
        locale.enable = true;
        network.enable = true;
        sound.enable = true;
        fonts.enable = true;
      };
      services = {
        docker.enable = true;
        ssh.enable = true;
        swayidle.enable = true;
        xserver.enable = true;
      };
      setups = {
        social.enable = true;
        terminal.enable = true;
      };
      personal = {
        ssh.cryomyst = true;
      };
    };

    cryo.core = {
      nixos.config = {
        security = {
          pam = {
            services = {
              sddm.enableGnomeKeyring = true;
            };
          };
        };

        programs = {
          dconf.enable = true;
          noisetorch.enable = true;
          zsh.enable = true;
          nix-ld.enable = true;
          thunar = {
            enable = true;
            plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
          };
        };

        services = {
          printing.enable = true;
          dbus.enable = true;
          gnome.gnome-keyring.enable = true;
          gvfs.enable = true;
          udisks2.enable = true;
          devmon.enable = true;
          tumbler.enable = true;

          greetd = {
            enable = true;
            settings = rec {
              initial_session = {
                command = "${pkgs.sway}/bin/sway";
                user = "${config.cryo.core.nixos.username}";
              };
              default_session = initial_session;
            };
          };
        };
      };
      home-manager.config = {
        home = {
          packages = with pkgs; [
            # firefox
            firefox-devedition
            obs-studio
            obsidian
            remmina
            freerdp
            file-roller
            gitkraken
            vscode
          ];
        };
      };
    };
  };
}
