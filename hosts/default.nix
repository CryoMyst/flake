{ inputs, config, withSystem, ...}: {
  flake.nixosConfigurations."cryo-desktop" = withSystem "x86_64-linux" ({ pkgs, ... }: 
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = inputs // {
        flake = {
          lib = config.flake.lib;
        };
      };
      modules = [
        config.flake.modules.nixos
        config.flake.modules.personal
        inputs.host-extra.nixosModules.default
        ./cryo-desktop/configuration.nix
      ];
    }
  );
}
