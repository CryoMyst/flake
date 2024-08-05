{
  outputs = inputs @ {flake-parts, ...}: flake-parts.lib.mkFlake {inherit inputs;} {imports = [./parts.nix];};

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wfvm.url = "git+https://git.m-labs.hk/m-labs/wfvm";
    nixvirt.url = "github:AshleyYakeley/NixVirt";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    wrapper-manager.url = "github:viperML/wrapper-manager";
    devenv.url = "github:cachix/devenv";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = "github:nix-community/nur";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Use for host if certain options need to be secret
    host-extra.url = "path:./modules/blank_flake_module";
  };
}
