{
  inputs,
  config,
  ...
}:
{
  # Overwrite and add new arguments to all flake modules.
  _module.args = {
    namespace = config.flake.namespace;

    # Initialize nixpkgs instance with custom overlays.
    pkgs = import inputs.nixpkgs {
      overlays = [
        (final: prev: {
          # Todo: actually append overlays from "/overlays/overlay-name/default.nix" files.
        })
      ];
    };
  };
}
