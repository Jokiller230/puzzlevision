{ ... }:
{
  imports = [
    ./hardware.nix
    ./hardware-generated.nix
  ];

  # Configure Sops
  sops.defaultSopsFile = ./secrets/users.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  programs.steam.enable = true;

  puzzlevision = {
    users.jo = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
      extraGroups = [
        "wheel"
        "docker"
      ];
    };

    archetypes.laptop.enable = true;
    system.kernel.version = "linuxPackages_6_16";
  };

  boot = {
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
  system.stateVersion = "25.11";
}
