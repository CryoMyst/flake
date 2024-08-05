Notes:
* Setup a proper shell with all tools required for the flake
* Make directory structure and module options less complicated somehow, maybe wrap them
* Create a script to download an use nix portable
* Split dev environment into a shell wrapping everything, disallow home-manager
* Create bootstrap script, uses --impure, existing /etc/nixos/configuration.nix and --override-input with the current channel to add basic things such as openssh keys and nix builders
    * This could be a custom iso, use nixos-generators
* Allow impure systems for work environments to import files from outside flake
* Setup script to generate actual hardware details for the system (CPU, GPU, Memory, etc)
* Impermanence
* Neovim