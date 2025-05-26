{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  # Setup Sops
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  puzzlevision = {
    users.cyn = {
      enable = true;
      hashedPassword = "$6$mvK9bT756Aok54Vt$vBRnT66Vb3HL0Y5rEMJlHvKkvzVQ.KUciInTmW3FCBFT00IuFMpz3q9RhXPLTLMRPho65bTg9hMnFPb84I774.";
      extraGroups = [
        "wheel"
        "docker"
      ];
    };

    archetypes.server.enable = true;

    services = {
      traefik = {
        enable = true;
        sopsFile = ./secrets/traefik.env;
        sopsFormat = "dotenv";
      };

      duckdns = {
        enable = true;
        sopsFile = ./secrets/duckdns.env;
        sopsFormat = "dotenv";
      };

      vaultwarden = {
        enable = true;
        sopsFile = ./secrets/vaultwarden.env;
        sopsFormat = "dotenv";
      };

      homepage = {
        enable = true;
        configDir = ./resources/homepage-config;
      };

      atticd = {
        enable = true;
        sopsFile = ./secrets/atticd.env;
        sopsFormat = "dotenv";
      };
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * * cyn docker exec -u www-data nextcloud-nextcloud-1 php /var/www/html/cron.php"
      "*/15 * * * * cyn docker exec -u www-data nextcloud-nextcloud-1 php /var/www/nextcloud/occ preview:pre-generate"
      "* 3 * * * cyn cd /home/cyn/docker/compose/satisfactory && docker compose up -d --force-recreate"
    ];
  };

  environment.systemPackages = with pkgs; [
    nano
  ];

  networking.hostName = "absolutesolver";
  system.stateVersion = "25.05";
}
