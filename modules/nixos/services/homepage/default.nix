{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.services.homepage;
in {
  options.${namespace}.services.homepage = {
    enable = mkEnableOption "Homepage, an intuitive dashboard for your services.";
    subdomain = mkOpt types.str "home" "The subdomain, of the system domain, the service should be exposed on.";
    configDir = mkOpt types.path null "The config directory, which will be copied to the Homepage directory during compilation.";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/lib/containers/homepage 0700 root root -"
      "d /var/lib/containers/homepage/config 0700 root root -"
      "d /var/lib/containers/homepage/images 0700 root root -"
    ];

    # Copy files from homepageConfigDirectory to the target directory
    system.activationScripts.homepage = ''
      cp -r ${cfg.configDir}/* /var/lib/containers/homepage/
    '';

    virtualisation.oci-containers.containers.homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;
      hostname = config.networking.hostName;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homepage.entrypoints" = "websecure";
        "traefik.http.routers.homepage.rule" = "Host(`${cfg.subdomain}.${config.${namespace}.services.domain}`)";
        "traefik.http.services.homepage.loadbalancer.server.port" = "3000";
      };
      volumes = [
        "/var/lib/containers/homepage/config:/app/config:rw"
        "/var/lib/containers/homepage/images:/app/public/images:rw"

        # Optional, used for docker integration.
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = {
        "HOMEPAGE_ALLOWED_HOSTS" = "${cfg.subdomain}.${config.${namespace}.services.domain}";
      };
      extraOptions = ["--network=proxy"];
    };
  };
}
