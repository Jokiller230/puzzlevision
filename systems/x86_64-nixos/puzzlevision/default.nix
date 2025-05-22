{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  # Todo: automate this globally for all workstation and server archetypes!
  # Configure Sops
  sops.defaultSopsFile = ./secrets/users.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # Todo: automate this import in users module!
  # Require user password secrets for users
  sops.secrets."users/jo/password_hash".neededForUsers = true;

  puzzlevision = {
    users.jo = {
      enable = true;
      #password = "4868320069443";
      hashedPasswordFile = config.sops.secrets."users/jo/password_hash".path; # For testing only, replace with sops secret before production use
      extraGroups = ["wheel"];
    };

    archetypes.laptop.enable = true;
  };

  # Configure 8GB SWAP partition
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  boot = {
    # Configure additional kernel modules.
    extraModulePackages = [
      pkgs.linuxPackages_latest.rtl8821ce # Use custom network-card driver.
    ];

    blacklistedKernelModules = [
      "rtw88_8821ce" # Block the default network-card driver.
    ];
  };

  networking.hostName = "puzzlevision";
  system.stateVersion = "25.05";
}
