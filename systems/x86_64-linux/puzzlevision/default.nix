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

  nixpkgs = {
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
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      keep-derivations = true;
      keep-outputs = true;
      max-jobs = "auto";
      warn-dirty = false;
    };

    # Garbage collection configuration.
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };

  # Set hostname
  networking.hostName = "puzzlevision";

  # Enable networking through networkmanager (required for most desktop environments).
  networking.networkmanager.enable = true;

  boot = {
    # Always run the latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Configure additional kernel modules.
    extraModulePackages = [
      pkgs.linuxPackages_latest.rtl8821ce # Use custom network-card driver.
    ];

    blacklistedKernelModules = [
      "rtw88_8821ce" # Block the default network-card driver.
    ];

    # Grub configuration.
    loader.grub = {
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

  # Bluetooth configuration.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;

    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
        KernelExperimental = "true";
      };
    };
  };

  # Enable Gnome
  puzzlevision.desktop.gnome.enable = true;

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
    backupFileExtension = "homeManagerBackup";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    firefox
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
