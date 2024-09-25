{
  lib,
  namespace,
  config,
  host,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.duckdns;
in {
  options.${namespace}.services.duckdns = {
    enable = mkEnableOption "Enable DuckDNS, the dynamic dns service. Will periodically refresh your IP.";
  };

  config = mkIf cfg.enable {
    sops.secrets.duckdns = {
      sopsFile = lib.snowfall.fs.get-file "secrets/duckdns.service.env";
      format = "dotenv";
    };

    virtualisation.oci-containers.containers.duckdns = {
      image = "lscr.io/linuxserver/duckdns:latest";
      autoStart = true;
      hostname = host;
      environmentFiles = [
        config.sops.secrets.duckdns.path
      ];
    };
  };
}
