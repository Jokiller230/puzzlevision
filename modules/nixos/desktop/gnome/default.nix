{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
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
      resources # System resource manager
    ];
  };
}
