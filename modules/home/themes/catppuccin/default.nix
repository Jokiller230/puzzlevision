{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  config,
  ...
}: {
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "frappe";

    pointerCursor.enable = true;
    pointerCursor.accent = "blue";
    pointerCursor.flavor = "frappe";
  };
}