{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.traefik;
in {
  options.${namespace}.services.traefik = {
    enable = mkEnableOption "Enable the Traefik service.";
    cloudflareEmail = mkOption {
      type = types.str;
      default = config.${namespace}.admin.email;
      example = "system@thevoid.cafe";
      description = "Specify the E-Mail associated with your Cloudflare account for ACME.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 8080 443]; # http, dashboard, https

    systemd.services.traefik = {
      environment = {
        CF_API_EMAIL = cfg.cloudflareEmail;
      };
      serviceConfig = {
        EnvironmentFile = [config.sops.secrets."services/cloudflare/api_key".path];
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
              email = cfg.cloudflareEmail;
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
  };
}
