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
  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = { enable = mkEnableOption "gnome"; };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    # Enable GNOME and GDM.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gedit
      cheese
      geary
      yelp # Help view
      epiphany # Gnome web
      gnome-console
      gnome-terminal
      gnome-music
      tali # Poker game
      iagno # Go game
      hitori # Sudoku game
      gnome-contacts
      gnome-initial-setup
      gnome-system-monitor
    ];

    programs.dconf.enable = true;

    services.gnome.gnome-keyring.enable = true;

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      blackbox-terminal # Terminal app
      resources # System resource manager
    ];
  };
}
