{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.traefik;
in {
  options.${namespace}.services.traefik = { enable = mkEnableOption "Enable the Traefik service."; };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    systemd.services.traefik = {
      environment = {
        CF_API_EMAIL = config.sops.secrets."cloudflare/api_email".path;
        CF_API_KEY = config.sops.secrets."cloudflare/api_key".path;
      };
    };

    services.traefik = {
      enable = true;

      staticConfigOptions = {
        log = {
          level = "INFO";
          filePath = "/var/log/traefik.log";
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
              email = "johannesreckers2006@gmail.com";
              storage = "/var/lib/traefik/acme.json";
              caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
              dnsChallenge = {
                provider = "cloudflare";
                resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
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
                main = "voidtales.dev";
                sans = ["*.voidtales.dev"];
              }
              {
                main = "voxtek.enterprises";
                sans = ["*.voxtek.enterprises"];
              }
              {
                main = "thevoid.cafe";
                sans = ["*.thevoid.cafe"];
              }
              {
                main = "reckers.dev";
                sans = ["*.reckers.dev"];
              }
              {
                main = "rhysbot.co.uk";
                sans = ["*.rhysbot.co.uk"];
              }
            ];
          };
        };
      };
    };

    # Todo: continue with "traefik" configuration and test it on a running system
  };
}
