{
  lib,
  pkgs,
  config,
  home-manager,
  flake,
  ...
}: let
  cfg = config.cryo.core.nixos;
  mergeType = flake.lib.types.merge;
in {
  options.cryo.core.nixos = {
    enable = lib.mkEnableOption "Enable nixos module";
    stateVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''Home-manager state version'';
    };
    username = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''Username of the machine'';
    };
    hostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''Hostname of the machine'';
    };
    userConfig = lib.mkOption {
      type = mergeType;
      default = {};
      description = ''User configuration'';
    };
    config = {
      programs = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos program configuration'';
      };
      users = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos user configuration'';
      };
      services = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos service configuration'';
      };
      hardware = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos hardware configuration'';
      };
      boot = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos boot configuration'';
      };
      fonts = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos fonts configuration'';
      };
      time = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos time configuration'';
      };
      i18n = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos i18n configuration'';
      };
      virtualisation = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos virtualisation configuration'';
      };
      environment = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos environment configuration'';
      };
      systemd = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos systemd configuration'';
      };
      security = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos security configuration'';
      };
      xdg = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos xdg configuration'';
      };
      documentation = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos documentation configuration'';
      };
      networking = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos networking configuration'';
      };
      fileSystems = lib.mkOption {
        type = mergeType;
        default = {};
        description = ''nixos file systems configuration'';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.stateVersion != null;
        message = "cryo: core.nixos - stateVersion must be set";
      }
      {
        assertion = cfg.username != null;
        message = "cryo: core.nixos - username must be set";
      }
      {
        assertion = cfg.hostname != null;
        message = "cryo: core.nixos - hostname must be set";
      }
    ];

    # Set top level config attributes for nixos only when the module is actually enabled
    programs = cfg.config.programs;
    users = lib.mkMerge [
      cfg.config.users
      {
        users.${cfg.username} = cfg.userConfig;
      }
    ];
    services = cfg.config.services;
    hardware = cfg.config.hardware;
    boot = cfg.config.boot;
    fonts = cfg.config.fonts;
    time = cfg.config.time;
    i18n = cfg.config.i18n;
    virtualisation = cfg.config.virtualisation;
    environment = cfg.config.environment;
    systemd = cfg.config.systemd;
    security = cfg.config.security;
    xdg = cfg.config.xdg;
    documentation = cfg.config.documentation;
    networking = cfg.config.networking;
    fileSystems = cfg.config.fileSystems;

    # Setup system state version
    system.stateVersion = cfg.stateVersion;

    # Setup nixpkgs
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
      };
    };

    # Setup nix
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        sandbox = true;
        auto-optimise-store = true;
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = ["05:00"];
      };
    };
  };
}
