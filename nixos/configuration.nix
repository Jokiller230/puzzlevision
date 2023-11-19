{
  inputs,
  lib,
  config,
  pkgs,
  catppuccinifier,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    # Configure your nixpkgs instance
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

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

  networking.wg-quick = {
    interfaces.homelab = {
      privateKey = "kJ+2MOoYbtI6K00pJbVQshD7bXx/pjKw01wlMih9FFI=";
      address = [ "10.8.0.2/24" ];
      dns = [ "1.1.1.1" ];

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "MTUi5FzlUQX1Vl2PLC72hnZnREn5kYRGqS6QSnaFeyQ=";
          presharedKey = "Spzeg7KwMXuczdkpMygmzix5QBkgTOrR3lLlO7862yw=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "jo-server.duckdns.org:51820";
          persistentKeepalive = 0;
        }
      ];
    };
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    jo = {
      isNormalUser = true;
      description = "Jo";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        discord
        ciscoPacketTracer8
        wireshark
        joplin-desktop
        teamspeak_client
	      virtualbox
      ];
    };

    work = {
      isNormalUser = true;
      description = "Work";
      initialPassword = "fortnite";
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [
        jetbrains.webstorm
        jetbrains.phpstorm
        teams-for-linux
        enpass
      ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    firefox
    thunderbird
    vlc
    libreoffice
    wineWowPackages.waylandFull
    xorg.xf86inputlibinput
    gimp
    ungoogled-chromium

    # For development
    vscodium
    git
    nodejs_20
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
