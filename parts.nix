{
  inputs,
  lib,
  ...
}: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  imports = [
    ./hosts
    ./lib
    ./modules
    ./packages
    ./shells
    
    # ./test.nix
  ];
}
