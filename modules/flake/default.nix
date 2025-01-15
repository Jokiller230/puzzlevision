{
  imports = [
    # Automagically imports overlays from "/overlays/overlay-name" and applies them to pkgs.
    # Also applies some other useful arguments, like namespace, to all flake modules.
    ./arguments.nix

    # Automagically imports systems from "/systems/arch-classname/system-name".
    ./systems.nix
  ];
}
