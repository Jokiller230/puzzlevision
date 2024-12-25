{
  lib,
  ...
}: with lib;
rec {
  ## Create a NixOS module option. (Stolen from Jake Hamilton)
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };
}
