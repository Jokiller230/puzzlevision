{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  # Todo: automate this globally for all workstation and server archetypes!
  # Configure Sops
  sops.defaultSopsFile = ./secrets/users.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;

  puzzlevision = {
    users.jo = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
      extraGroups = [
        "wheel"
        "docker"
      ];
    };

    users.drfrontend = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
      extraGroups = [
        "wheel"
        "docker"
      ];
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

    # Grub configuration
    loader.grub = {
      # Minecraft bootloader theme
      minegrub-theme = {
        enable = true;
        splash = "100% Flakes!";
        background = "background_options/1.18 - [Caves And Cliffs 2].png";
        boot-options-count = 4;
      };
    };
  };

  networking.hostName = "puzzlevision";
  system.stateVersion = "25.05";
}
