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

  # Create some helpful groups for development
  # and permission related reasons.
  users.groups = {
    www-data.gid = 33;
  };

  puzzlevision = {
    users.jo = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
      extraGroups = [
        "wheel"
        "docker"
        "www-data"
      ];
    };

    archetypes.laptop.enable = true;
  };

  # Minecraft bootloader theme
  boot.loader.grub.minegrub-theme = {
    enable = true;
    splash = "100% Flakes!";
    background = "background_options/1.18 - [Caves And Cliffs 2].png";
    boot-options-count = 4;
  };

  networking.hostName = "puzzlevision";
  system.stateVersion = "25.11";
}
