{
  imports = [
    # Applies some useful arguments, like namespace, to all flake modules.
    ./arguments.nix

    # Automagically imports libs from "/lib/lib-name" and applies them to the `lib.${namespace}` or `puzzlevision.lib` module argument.
    ./lib.nix

    # Recursively imports overlays from "/overlays/overlay-name" and applies them to the `pkgs` or `puzzlevision.pkgs` module argument.
    # ./overlays.nix

    # Automagically imports systems from "/systems/arch-classname/system-name".
    ./systems.nix
  ];
}
