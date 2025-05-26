{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.services.traefik;
in
{
  options.${namespace}.services.traefik = {
    enable = mkEnableOption "the Traefik service.";
    sopsFile = mkOpt types.path null "The location of the sops secret file for the Traefik service.";
    sopsFormat = mkOpt types.str null "The format of the sops secret file for the Traefik service.";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      8080
      443
    ]; # http, dashboard, https

    sops.secrets."services/traefik" = {
      sopsFile = cfg.sopsFile;
      format = cfg.sopsFormat;
    };

    systemd.services.traefik = {
      serviceConfig = {
        EnvironmentFile = [ config.sops.secrets."services/traefik".path ];
      };
    };

    services.traefik = {
      enable = true;
      group = "docker";

      staticConfigOptions = {
        log = {
          level = "INFO";
          filePath = "/var/lib/traefik/traefik.log";
          noColor = false;
          maxSize = 100;
          compress = true;
        };

        api = {
          dashboard = true;
          insecure = true;
        };

        providers = {
          docker = {
            exposedByDefault = false;
            network = "proxy";
          };
        };

        certificatesResolvers = {
          letsencrypt = {
            acme = {
              email = config.${namespace}.services.mail;
              storage = "/var/lib/traefik/acme.json";
              #caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # Uncomment this when testing stuff!
              dnsChallenge = {
                provider = "cloudflare";
              };
            };
          };
        };

        entryPoints.web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };

        entryPoints.websecure = {
          address = ":443";
          http.tls = {
            certResolver = "letsencrypt";
            domains = [
              {
                main = "thevoid.cafe";
                sans = [ "*.thevoid.cafe" ];
              }
              {
                main = "rhysbot.co.uk";
                sans = [ "*.rhysbot.co.uk" ];
              }
            ];
          };
        };
      };
    };
  };
}
