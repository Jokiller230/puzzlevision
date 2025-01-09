{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  system,
  ...
}: with lib; with lib.${namespace};
{
  imports = [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Configure Sops
  sops.defaultSopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
  sops.age.keyFile = "/var/lib/sops-nix/key.txt"; # The main AGE key is expected in this location, it is only needed for this system.

  # Sops keys
  sops.secrets."user/jo/password_hash".neededForUsers = true;

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
    security.yubikey = {
      enable = true;
      enable-agent = true;
    };
  };

  # Enable flatpak support.
  services.flatpak.enable = true;

  # Set trusted users (Primarily used for cachix)
  nix.settings.trusted-users = [ "root" "jo" ];

  # Configure users.
  snowfallorg.users.jo.admin = true;
  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = [ "dialout" "docker" ];
  users.users.jo.hashedPasswordFile = config.sops.secrets."user/jo/password_hash".path;

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    inputs.zen-browser.packages."${system}".default
    inputs.ghostty.packages.x86_64-linux.default
    vlc

    ## Security
    pinentry-tty
    gnupg
  ];

  system.stateVersion = "23.05";
}
