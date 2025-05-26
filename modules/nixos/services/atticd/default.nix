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

  cfg = config.${namespace}.services.atticd;
in
{
  options.${namespace}.services.atticd = {
    enable = mkEnableOption "the attic service, a multi-tenant nix binary cache.";
    sopsFile = mkOpt types.path null "The location of the sops secret file for the Atticd service.";
    sopsFormat = mkOpt types.str null "The format of the sops secret file for the Atticd service.";
    subdomain =
      mkOpt types.str "cache"
        "The subdomain, of the system domain, the service should be exposed on.";
  };

  config = mkIf cfg.enable {
    sops.secrets."services/atticd" = {
      sopsFile = cfg.sopsFile;
      format = cfg.sopsFormat;
    };

    services.atticd = {
      enable = true;

      environmentFile = config.sops.secrets."services/atticd".path;

      settings = {
        listen = "[::]:3900";
        jwt = { };

        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };

        compression = {
          type = "zstd";
          level = 12;
        };

        garbage-collection.interval = "8 hours";
      };
    };

    services.traefik.dynamicConfigOptions = {
      http = {
        services.atticd.loadBalancer.servers = [ { url = "http://localhost:3900"; } ];
        routers.atticd = {
          entryPoints = [ "websecure" ];
          service = "atticd";
          rule = "Host(`${cfg.subdomain}.${config.${namespace}.services.domain}`)";
        };
      };
    };
  };
}
