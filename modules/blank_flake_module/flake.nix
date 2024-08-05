{
  outputs = inputs @ {nixpkgs, ...}: {
    nixosModules.default = {...}: {
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
}
