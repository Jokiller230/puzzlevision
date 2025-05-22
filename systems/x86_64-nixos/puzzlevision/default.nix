{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  # Todo: automate this globally for all workstation and server archetypes!
  # Configure Sops
  sops.defaultSopsFile = ./secrets/users.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  puzzlevision = {
    users.jo = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
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
