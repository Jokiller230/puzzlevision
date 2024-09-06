{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # Instance of `pkgs` with overlays and custom packages applied.
  pkgs,
  # All flake inputs.
  inputs,

  # Additional metadata, provided by Snowfall Lib.
  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  # All other arguments come from the system system.
  config,
  ...
}:
with lib;
with lib.${namespace};
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

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Set console keymap.
  console.keyMap = "de";
  services.xserver = {
    xkb.layout = "de";
  };

  # Enable the power-profiles-daemon service for improved battery management.
  services.power-profiles-daemon.enable = true;

  # Enable printing.
  services.printing.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Sound configuration based on pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Set system Type
  puzzlevision.archetypes.workstation.enable = true;

  # Enable flatpak support.
  services.flatpak.enable = true;

  # Enable iio-sensor for automatic screen rotation and similar features.
  hardware.sensor.iio.enable = true;

  # Enable support for flipper zero devices
  hardware.flipperzero.enable = true;

  # Configure system-wide default shell.
  environment.shells = with pkgs; [ fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  # Configure users.
  snowfallorg.users.jo.admin = true;

  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = [ "dialout" "docker" ];

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackupFile69";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    firefox
    chromium
    vlc
    spotify

    ### Bluetooth
    bluez

    ### Fonts
    noto-fonts
    noto-fonts-color-emoji
  ];

  system.stateVersion = "23.05";
}
