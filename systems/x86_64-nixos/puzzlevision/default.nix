{ ... }:
{
  imports = [
    ./hardware.nix
    ./hardware-generated.nix
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
    system.kernel.version = "linuxPackages_zen";
  };

  # Configure some last-resort aggressive nix-daemon OOM protection
  systemd = {
    # Create a separate slice for nix-daemon that is
    # memory-managed by the userspace systemd-oomd killer
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "50%";
    };
    services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
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
