{
  config,
  lib,
  ...
}: {
  options = {
    flake.modules = {
      nixos = lib.mkOption {
        type = lib.types.raw;
        default = config.flake.lib.fileSystem.mkModuleFromDirectory ./nixos;
      };
      personal = lib.mkOption {
        type = lib.types.raw;
        default = config.flake.lib.fileSystem.mkModuleFromDirectory ./personal;
      };
    };
  };
}
