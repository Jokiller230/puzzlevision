{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    outputs.nixosModules.desktop.kde
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
  
  # Install the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Improve SSD performance
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
    efiSupport = true;

    extraEntries = ''
      menuentry "Reboot" {
        reboot
      }
      menuentry "Poweroff" {
        halt
      }
    '';
  };

  networking.hostName = "puzzlevision";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Configure console keymap
  console.keyMap = "de";

  # Enable the TLP service for improved battery management
  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth on boot
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
  };

  # Configure fish as the default shell
  environment.shells = with pkgs; [ fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  # Define a user account.
  users.users = {
    jo = {
      isNormalUser = true;
      description = "Jo";
      extraGroups = [ "networkmanager" "wheel" "docker" "tty" "dialout" ];
    };

    work = {
      isNormalUser = true;
      description = "Work";
      initialPassword = "fortnite";
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [
        jetbrains.phpstorm
        teams-for-linux
        enpass
        thunderbird
      ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.systemPackages = with pkgs; [
    nano
    firefox
    vlc
    libreoffice

    # For development
    git
    bun

    # Home manager
    home-manager
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
