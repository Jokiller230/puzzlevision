{
  lib,
  self,
  ...
}: {
  # Create a NixOS module option on a single line.
  mkOpt = type: default: description:
    lib.mkOption {inherit type default description;};

  # Create a simple bool options
  mkBool = default: description:
    lib.mkOption {
      inherit default description;
      type = lib.types.bool;
    };

  # Create a module compliant with the NixOS module system.
  mkModule = {
    name ? "puzzlevision",
    class,
    modules,
  }: {
    _class = class;
    # Template: "[path-to-flake]/flake.nix#[class-name]Modules.[module-name]"
    # Example: "[path-to-flake]/flake.nix#nixosModules.system.audio"
    _file = "${self.outPath}/flake.nix#${class}Modules.${name}";
    imports = modules;
  };

  # TODO: add mkIfElse function
}
