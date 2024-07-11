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
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    outputs.nixosModules.desktop.gnome
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (final: prev: {
        linuxPackages_latest = prev.linuxPackages_latest.extend (lpfinal: lpprev: {
          rtl8821ce = lpprev.rtl8821ce.overrideAttrs ({src, ...}: {
            version = "${lpprev.kernel.version}-unstable-2024-03-26";
            src = final.fetchFromGitHub {
              inherit (src) owner repo;
              rev = "f119398d868b1a3395f40c1df2e08b57b2c882cd";
              hash = "sha256-EfpKa5ZRBVM5T8EVim3cVX1PP1UM9CyG6tN5Br8zYww=";
            };
          });
        });
      })
    ];
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

  # Set hostname
  networking.hostName = "puzzlevision";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Install the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network card driver
  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.rtl8821ce
  ];

  boot.blacklistedKernelModules = [
    "rtw88_8821ce"
  ];

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

  # Enable the power-profiles-daemon service for improved battery health
  services.power-profiles-daemon.enable = true;

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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;

    settings = {
      General = {
        Disable = "Handsfree";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
        KernelExperimental = "true";
      };
    };
  };

  services.blueman.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;

  programs.steam = {
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable automatic screen rotation and similar features
  hardware.sensor.iio.enable = true;

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

  # Define user accounts
  users.users = {
    jo = {
      isNormalUser = true;
      description = "Jo";
      initialPassword = "jo";
      extraGroups = [ "networkmanager" "wheel" "docker" "tty" "dialout" ];
    };

    work = {
      isNormalUser = true;
      description = "Work account";
      initialPassword = "work";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };

    gaming = {
      isNormalUser = true;
      description = "Gaming account";
      initialPassword = "gaming";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    nano
    firefox
    vlc
    libreoffice
    spotify

    # Bluetooth
    bluez
    bluez-tools

    # Fonts
    noto-fonts
    noto-fonts-color-emoji
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
