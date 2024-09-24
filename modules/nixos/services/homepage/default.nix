{
  lib,
  namespace,
  config,
  host,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.homepage;
  homepageConfigDirectory = lib.snowfall.fs.get-file "resources/services/homepage";
in {
  options.${namespace}.services.homepage = { enable = mkEnableOption "Enable Homepage, an intuitive dashboard for your services."; };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/containers/homepage/config 0700 root root -"
      "d /var/lib/containers/homepage/images 0700 root root -"

      "d /var/lib/containers/homepage 0700 root root - - - exec cp -r ${homepageConfigDirectory}/* /var/lib/containers/homepage"
    ];

    virtualisation.oci-containers.containers.homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;
      hostname = host;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homepage.entrypoints" = "websecure";
        "traefik.http.routers.homepage.rule" = "Host(`home.thevoid.cafe`)";
        "traefik.http.services.homepage.loadbalancer.server.port" = "3000";
      };
      volumes = [
        "/var/lib/containers/homepage/config:/app/config:rw"
        "/var/lib/containers/homepage/images:/app/public/images:rw"
        "/var/run/docker.sock:/var/run/docker.sock:ro" # Optional, used for docker integration.
      ];
      extraOptions = ["--network=proxy"];
    };
  };
}
