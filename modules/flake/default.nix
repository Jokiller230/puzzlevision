{
  imports = [
    # Exposes nixosModules and homeModules on flake outputs.
    ./modules.nix

    # Automagically imports libs from "/lib/lib-name" and exposes them to the `flake.lib` output.
    ./lib.nix

    # Automagically imports systems from "/systems/arch-classname/system-name".
    ./systems.nix
  ];
}
