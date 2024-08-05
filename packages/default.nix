{
  ...
}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    packages.pyfa = config.flake.lib.mkDefaultPackage ./pyfa;
  };
}
