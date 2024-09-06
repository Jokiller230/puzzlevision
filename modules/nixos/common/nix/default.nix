{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.nix;
in {
  options.${namespace}.common.nix = { enable = mkEnableOption "nix"; };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [ "nix-command" "flakes" ];
        keep-derivations = true;
        keep-outputs = true;
        max-jobs = "auto";
      };

      # Garbage collection configuration.
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };
    };
  }
}
