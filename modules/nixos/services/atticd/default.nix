{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.services.atticd;
in {
  options.${namespace}.services.atticd = {
    enable = mkEnableOption "the attic service, a multi-tenant nix binary cache.";
    sopsFile = mkOpt types.str null "The location of the sops secret file for the Atticd service.";
    sopsFormat = mkOpt types.str null "The format of the sops secret file for the Atticd service.";
    subdomain = mkOpt types.str "cache" "The subdomain, of the system domain, the service should be exposed on.";
  };

  config = mkIf cfg.enable {
    config.sops.secrets."services/atticd" = {
      sopsFile = cfg.sopsFile;
      format = cfg.sopsFormat;
    };

    services.atticd = {
      enable = true;

      environmentFile = config.sops.secrets."services/atticd".path;

      settings = {
        listen = "[::]:3900";
        jwt = {};

        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };

    services.traefik.dynamicConfigOptions = {
      http = {
        services.atticd.loadBalancer.server.url = "http://localhost:3900";
        routers.atticd = {
          entrypoints = ["websecure"];
          rule = "Host(`${cfg.subdomain}.${config.services.domain}`)";
        };
      };
    };
  };
}
