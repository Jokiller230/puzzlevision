{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.archetypes.workstation;
in {
  options.${namespace}.archetypes.workstation = { enable = mkEnableOption "Enable the workstation archetype for your current system"; };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "0"; # Chromium/Electron native Wayland support (Buggy)
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
        hardware.enable = true; # Common hardware support and tweaks
        fonts.enable = true; # Common fonts and font management tweaks
        audio.enable = true; # Audio setup
      };

      desktop.gnome.enable = true;
    };
  };
}
