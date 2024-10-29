{
  lib,
  namespace,
  config,
  host,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.bluesky.pds;
in {
  options.${namespace}.services.bluesky.pds = {
    enable = mkEnableOption "Enable the Bluesky PDS, your own ATproto home!";
  };

  config = mkIf cfg.enable {
    sops.secrets.bluesky-pds = {
      sopsFile = lib.snowfall.fs.get-file "secrets/bluesky-pds.service.env";
      format = "dotenv";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/containers/bluesky 0700 root root -"
      "d /var/lib/containers/bluesky/pds 0700 root root -"
      "d /var/lib/containers/bluesky/pds/blobs 0700 root root -"
    ];

    virtualisation.oci-containers.containers.bluesky-pds = {
      image = "ghcr.io/bluesky-social/pds:0.4";
      autoStart = true;
      hostname = host;
      environmentFiles = [
        config.sops.secrets.bluesky-pds.path
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.bluesky-pds.entrypoints" = "websecure";
        "traefik.http.routers.bluesky-pds.rule" = "HostRegexp(`{subdomain:[a-zA-Z0-9-]+}.bsky.thevoid.cafe`)";
        "traefik.http.middlewares.bluesky-pds-header.headers.customrequestheaders.Host" = "{host}";
        "traefik.http.services.bluesky-pds.loadbalancer.server.port" = "2583";
      };
      volumes = [
        "/var/lib/containers/bluesky/pds:/pds"
      ];
      extraOptions = ["--network=proxy"];
    };
  };
}
