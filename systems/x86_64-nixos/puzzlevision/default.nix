{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  puzzlevision = {
    users.jo = {
      enable = true;
      password = "jo"; # For testing only, replace with sops secret before production use
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
