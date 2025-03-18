{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        # GNOME dynamic triple buffering
        # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
        src = final.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "vanvugt";
          repo = "mutter";
          rev = "triple-buffering-v4-47";
          hash = "sha256-6n5HSbocU8QDwuhBvhRuvkUE4NflUiUKE0QQ5DJEzwI=";
        };

        preConfigure = let
          gvdb = final.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "GNOME";
            repo = "gvdb";
            rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
            hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
          };
        in ''
          cp -a "${gvdb}" ./subprojects/gvdb
        '';
      });
    })
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
    common.kernel.version = "linuxPackages_latest";

    security.yubikey = {
      enable = true;
      enable-agent = true;
    };
  };

  # Enable flatpak support.
  services.flatpak.enable = true;

  # Set trusted users (Primarily used for cachix)
  nix.settings.trusted-users = ["root" "jo"];

  # Configure additional groups
  users.groups.www-data = {
    gid = 33;
  };

  # Configure users.
  snowfallorg.users.jo.admin = true;
  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = ["dialout" "docker" "www-data"];
  users.users.jo.hashedPasswordFile = config.sops.secrets."user/jo/password_hash".path;

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    inputs.ghostty.packages.x86_64-linux.default
    vlc

    ## Security
    pinentry-tty
    gnupg
  ];

  system.stateVersion = "23.05";
}
