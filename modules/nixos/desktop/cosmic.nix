{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable the x11 windowing system
  services.xserver.enable = true;

  # Enable Cosmic DE
  services.desktopManager.cosmic.enable = true;

  # Enable Cosmic greeter
  services.displayManager.cosmic-greeter.enable = true;
}
