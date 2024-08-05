{ config, lib, pkgs, ... }:
{
  options = {
    testing.pkgs = lib.mkOption {
      type = lib.types.raw;
      default = pkgs;
    };
  };
  
  config = {
    environment.systemPackages = [
      config.testing.pkgs.hello
    ];
  };
}