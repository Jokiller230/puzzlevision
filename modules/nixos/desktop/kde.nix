{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable the x11 windowing system
  services.xserver.enable = true;

  # Enable the SDDM display manager.
  services.displayManager.sddm.enable = true;

  # Enable the KDE Plasma 6 desktop environment.
  services.desktopManager.plasma6.enable = true;

  # Enable KDE-Connect
  programs.kdeconnect.enable = true;

  # On-screen keyboard and automatic screen rotation dependencies
  environment.systemPackages = with pkgs; [
    maliit-keyboard
    iio-sensor-proxy
  ];
}
