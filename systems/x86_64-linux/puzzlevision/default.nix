{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
{
  imports = [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Set hostname
  # Todo: move to common/networking module
  networking.hostName = "puzzlevision";

  boot = {
    # Configure additional kernel modules.
    extraModulePackages = [
      pkgs.linuxPackages_latest.rtl8821ce # Use custom network-card driver.
    ];

    blacklistedKernelModules = [
      "rtw88_8821ce" # Block the default network-card driver.
    ];
  };

  # Set timezone.
  time.timeZone = "Europe/Berlin";

  # Enable the power-profiles-daemon service for improved battery management.
  services.power-profiles-daemon.enable = true;

  # Enable printing.
  services.printing.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Set system configuration
  puzzlevision = {
    archetypes.workstation.enable = true;
  };

  # Enable flatpak support.
  services.flatpak.enable = true;

  # Configure users.
  snowfallorg.users.jo.admin = true;
  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = [ "dialout" "docker" ];

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    firefox
    chromium
    vlc
    spotify

    ## Security
    pinentry-tty
    gnupg
  ];

  system.stateVersion = "23.05";
}
