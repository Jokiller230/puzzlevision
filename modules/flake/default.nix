{
  imports = [
    # Exposes nixosModules and homeModules on flake outputs.
    ./modules.nix

    # Automagically imports libs from "/lib/lib-name" and exposes them to the `flake.lib` output.
    ./lib.nix

    # Recursively imports overlays from "/overlays/overlay-name" and exposes them to the `flake.overlays` output.
    #./overlays.nix

    # Automagically imports systems from "/systems/arch-classname/system-name".
    ./systems.nix

    # Automagically imports homes from "/homes/user-name".
    #./homes.nix
  ];
}
