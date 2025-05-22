{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = {
    enable = mkEnableOption "the gnome desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
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
      totem # Gnome videos
      hitori # Sudoku game
      gnome-contacts
      gnome-initial-setup
      gnome-system-monitor
    ];

    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      refine
      showtime
      resources
    ];
  };
}
