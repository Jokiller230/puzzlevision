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
  cfg = config.${namespace}.archetypes.workstation;
in {
  options.${namespace}.archetypes.workstation = { enable = mkEnableOption "Enable the workstation archetype for your current system"; };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Chromium/Electron native Wayland support
      MOZ_ENABLE_WAYLAND = "1"; # Firefox native Wayland support
    };

    # Enable modules
    puzzlevision = {
      common = {
        nix.enable = true; # Standard Nix configuration
        grub.enable = true; # Bootloader grub
        networking.enable = true; # Networkmanager configuration
        kernel.enable = true; # Kernel modifications
        bluetooth.enable = true; # Bluetooth support
        shell.enable = true; # Shell environment configuration
      };

      desktop.gnome.enable = true;
    };
  };
}
