{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
{
  imports = [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Setup Sops
  sops.defaultSopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  # Sops keys
  sops.secrets."services/cloudflare/api_key" = {};

  # Set hostname
  # Todo: move to common/networking module
  networking.hostName = "absolutesolver";

  # Set timezone.
  time.timeZone = "Europe/Berlin";

  # Enable docker and set it as the OCI container backend
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  # Set system configuration
  puzzlevision = {
    archetypes.server.enable = true;

    services = {
      traefik = {
        enable = true;
        cloudflareEmail = "johannesreckers2006@gmail.com";
      };

      vaultwarden.enable = true;
      homepage.enable = true;
      duckdns.enable = true;
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * * cyn docker exec -u www-data nextcloud-nextcloud-1 php /var/www/html/cron.php"
      "*/15 * * * * cyn docker exec -u www-data nextcloud-nextcloud-1 php /var/www/nextcloud/occ preview:pre-generate"
      #"*/30 * * * * cyn /home/jo/tools/FediFetcher/FediFetcher.sh"
    ];
  };

  # Configure users.
  snowfallorg.users.cyn.admin = true;
  users.users.cyn.isNormalUser = true;
  users.users.cyn.extraGroups = [ "dialout" "docker" ];

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Install required system packages
  environment.systemPackages = with pkgs; [
    ### General
    nano
    vim

    ## Runtimes
    nodejs_22
    bun
  ];

  system.stateVersion = "24.05";
}
