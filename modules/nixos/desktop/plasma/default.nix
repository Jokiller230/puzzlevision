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
  cfg = config.${namespace}.desktop.plasma;
in {
  options.${namespace}.desktop.plasma = { enable = mkEnableOption "Whether to enable the KDE Plasma desktop environment"; };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;

    programs.kdeconnect.enable = true;
  };
}