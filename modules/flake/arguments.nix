{
  lib,
  inputs,
  config,
  ...
}:
let
  ## Recursive loading of libraries, similar to snowfall lib.
  ## Logical flow: read files => merge all file outputs to single attr. set
  ## The directory in question is flake-root => lib
  ## The directory structure is:
  ## lib/
  ##   => libname
  ##     => default.nix
  ##   => libname2
  ##     => default.nix
  ##
  ## The structure of multiple libs is simply for organization and the attrs. of all default.nix files should still be merged
  ## into a single set.
  loadLibs = directory:
    builtins.foldl' (acc: name:
      let
        path = "${directory}/${name}";
        isDir = (builtins.getAttr name (builtins.readDir directory)) == "directory";
      in
        if isDir then
          lib.mergeAttrs acc (loadLibs path)
        else if name == "default.nix" then
          lib.mergeAttrs acc (import path { inherit lib; })
        else
          acc
    ) {} (builtins.attrNames (builtins.readDir directory));
in
{
  # Overwrite and add new arguments to all flake modules.
  _module.args = {
    namespace = config.flake.namespace;

    puzzlelib = loadLibs ../../lib;

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
