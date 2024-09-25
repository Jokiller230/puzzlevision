{
  lib,
  namespace,
  config,
  host,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.sharkey;
in {
  options.${namespace}.services.sharkey = { enable = mkEnableOption "Enable Sharkey, the activitypub-based microblogging service."; };

  config = mkIf cfg.enable {
    sops.secrets.sharkey-config = {
      sopsFile = lib.snowfall.fs.get-file "secrets/default.sharkey.service.yaml";
      format = "yaml";
    };

    sops.secrets.sharkey-docker-config = {
      sopsFile = lib.snowfall.fs.get-file "secrets/docker-env.sharkey.service.env";
      format = "dotenv";
    };

    sops.secrets.sharkey-meilisearch-config = {
      sopsFile = lib.snowfall.fs.get-file "secrets/meilisearch.sharkey.service.env";
      format = "dotenv";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/containers/sharkey 0700 991 991 -"
    ];

    system.activationScripts.sharkey-web = ''
      cp ${config.sops.secrets.sharkey-config.path} /var/lib/containers/sharkey/.config/default.yml
    '';

    virtualisation.oci-containers.containers.sharkey-web = {
      image = "registry.activitypub.software/transfem-org/sharkey:latest";
      autoStart = true;
      hostname = host;
      dependsOn = [ "sharkey-redis" "sharkey-db" ];
      environment = {
        NODE_ENV = "production";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.sharkey.entrypoints" = "websecure";
        "traefik.http.routers.sharkey.rule" = "Host(`voxtek.enterprises`)";
        "traefik.http.services.sharkey.loadbalancer.server.port" = "3000";
        # Homepage labels
        "homepage.group" = "Entertainment";
        "homepage.name" = "Sharkey";
        "homepage.icon" = "/images/logo.png";
        "homepage.href" = "https://voxtek.enterprises";
        "homepage.description" = "Private VoxTek themed Sharkey instance";
        "homepage.ping" = "https://voxtek.enterprises";
        "homepage.widget.type" = "mastodon";
        "homepage.widget.url" = "https://voxtek.enterprises";
      };
      volumes = [
        "/var/lib/containers/sharkey/files:/sharkey/files:rw"
        "/var/lib/containers/sharkey/.config:/sharkey/.config:ro"
      ];
      extraOptions = ["--network=proxy --network=sharknet"];
    };

    virtualisation.oci-containers.containers.sharkey-redis = {
      image = "docker.io/redis:7.0-alpine"
      autoStart = true;
      hostname = host;
      volumes = [
        "/var/lib/containers/sharkey/redis:/data:rw"
      ];
      extraOptions = ["--network=sharknet"]; # Todo: implement healthcheck
    }

    virtualisation.oci-containers.containers.sharkey-meilisearch = {
      image = "getmeili/meilisearch:v1.3.4"
      autoStart = true;
      hostname = host;
      volumes = [
        "/var/lib/containers/sharkey/meili_data:/meili_data:rw"
      ];
      environment = {
        MEILI_NO_ANALYTICS = "true";
        MEILI_ENV = "production";
      };
      environmentFiles = [
        config.sops.secrets.sharkey-meilisearch.path
      ];
      extraOptions = ["--network=sharknet"];
    }

    virtualisation.oci-containers.containers.sharkey-db = {
      image = "docker.io/postgres:16.1-alpine"
      autoStart = true;
      hostname = host;
      volumes = [
        "/var/lib/containers/sharkey/db:/var/lib/postgresql/data:rw"
      ];
      environmentFiles = [
        config.sops.secrets.sharkey-docker-config.path
      ];
      extraOptions = ["--network=sharknet"]; # Todo: implement healthcheck
    }

    # W.I.P Todo: finish Sharkey service
  };
}
