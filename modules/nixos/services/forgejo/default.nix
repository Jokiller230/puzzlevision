{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.forgejo;
in
{
  options.${namespace}.services.forgejo = {
    enable = mkEnableOption "Whether to enable the forgejo git service.";
  };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;

      database = {
        type = "postgres";
      };
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.thevoid.cafe";
          ROOT_URL = "https://git.thevoid.cafe/";
          HTTP_PORT = "3030";
        };
        service.DISABLE_REGISTRATION = true;
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };

    # TODO: finish this configuration

    services.traefik = {
      dynamicConfigOptions = {
        http = {
          routers.forgejo = {
            entryPoints = ["websecure"];
            rule = "Host(`git.thevoid.cafe`)";
            service = "forgejo";
          };

          services.forgejo.loadbalancer.server = {
            url = "http://localhost:3030";
          };
        };
      };
    };
  };
}
