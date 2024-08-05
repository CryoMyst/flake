{
  inputs,
  config,
  lib,
  withSystem,
  flake-parts-lib,
  ...
}: 
let
  c = config;
in {
  options = {
    flake.lib = {
      types = {
        merge = lib.mkOption {
          type = lib.types.raw;
          default = lib.mkOptionType {
            name = "merge";
            description = "merge attrsets";
            check = builtins.isAttrs;
            merge = loc: defs: (lib.mkMerge (builtins.map (def: def.value) defs));
          };
        };
      };

      fileSystem = {
        readDirectories = config.flake.lib.mkLibFunctionOption {
          name = "readDirectories";
          function = directory: (
            lib.attrsets.filterAttrs (name: value: value == "directory") (builtins.readDir directory)
          );
        };
        listNixFilesRecursive = config.flake.lib.mkLibFunctionOption {
          name = "listNixFilesRecursive";
          function = directory: (
            builtins.filter (name: lib.hasSuffix ".nix" name) (lib.filesystem.listFilesRecursive directory)
          );
        };
        mkModuleFromDirectory = config.flake.lib.mkLibFunctionOption {
          name = "mkModuleFromDirectory";
          function = directory: (
            { imports = (config.flake.lib.fileSystem.listNixFilesRecursive directory); }
          );
        };
      };

      mkLibFunctionOption = lib.mkOption {
        type = lib.types.raw;
        default = {
          name,
          function,
        }:
          lib.mkOption {
            type = lib.types.raw;
            default = function;
          };
      };
    };

    perSystem = flake-parts-lib.mkPerSystemOption ({
      system,
      pkgs,
      config,
      ...
    }: {
      options = {
        flake = {
          lib = {
            mkDefaultPackage = c.flake.lib.mkLibFunctionOption {
              name = "mkDefaultPackage";
              function = file: pkgs.callPackage file {};
            };
          };

          pkgs = {
            default = lib.mkOption {
              type = lib.types.raw;
              default = pkgs;
            };
            stable = lib.mkOption {
              type = lib.types.raw;
              default = import inputs.nixpkgs-stable { 
                inherit system; 
                config = {
                  allowUnfree = config.flake.pkgs.default.config.allowUnfree;
                };
              };
            };
            unstable = lib.mkOption {
              type = lib.types.raw;
              default = import inputs.nixpkgs-unstable { 
                inherit system; 
                config = {
                  allowUnfree = config.flake.pkgs.default.config.allowUnfree;
                };
              };
            };
            master = lib.mkOption {
              type = lib.types.raw;
              default = import inputs.nixpkgs-master { 
                inherit system; 
                config = {
                  allowUnfree = config.flake.pkgs.default.config.allowUnfree;
                };
              };
            };
          };
        };
      };
    });
  };
}
