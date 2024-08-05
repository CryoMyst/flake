{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cryo.programs.zsh;
in {
  options.cryo.programs.zsh = {
    enable = lib.mkEnableOption "Enable zsh module";
  };

  config = lib.mkIf cfg.enable {
    cryo.core = {
      nixos.config = {
        programs = {
          zsh.enable = true;
        };
        environment.shells = with pkgs; [zsh];
      };
      nixos.userConfig = {
        shell = pkgs.zsh;
      };
      home-manager.config = {
        programs = {
          zsh = {
            enable = true;
            autosuggestion.enable = true;
            enableCompletion = true;
            enableVteIntegration = true;
            history = {ignoreAllDups = true;};
            oh-my-zsh = {
              enable = true;
              plugins = [
                "git"
                "sudo"
                "docker"
                "docker-compose"
                "dotnet"
                "gitignore"
                "man"
                "rust"
                "terraform"
                "zoxide"
              ];
              theme = "robbyrussell";
            };
            syntaxHighlighting = {enable = true;};

            shellAliases = {
            };

            plugins = [
              {
                name = "zsh-nix-shell";
                file = "nix-shell.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "chisui";
                  repo = "zsh-nix-shell";
                  rev = "v0.7.0";
                  sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
                };
              }
            ];
          };
        };
      };
    };
  };
}
