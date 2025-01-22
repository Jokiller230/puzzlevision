{
  lib,
  ...
}:
{
  ## Create a NixOS module option as a one-liner.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Option description"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    lib.mkOption { inherit type default description; };
}
