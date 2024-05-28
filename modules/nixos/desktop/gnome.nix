{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    epiphany # Gnome web
    tali # Poker game
    iagno # Go game
    hitori # Sudoku game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
    geary
  ]);

  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];
}