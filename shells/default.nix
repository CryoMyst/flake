{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devshells.default = {
      packages = with pkgs; [
        sops
        age
        git
        nh
        statix
        alejandra
        jq
      ];
    };
  };
}
