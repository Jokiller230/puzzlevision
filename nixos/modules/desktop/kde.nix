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
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  environment.systemPackages = with pkgs; [
    lightly-boehs
    kde-rounded-corners
  ];

  programs.kdeconnect.enable = true;
}