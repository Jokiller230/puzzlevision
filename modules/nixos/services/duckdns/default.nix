{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.services.duckdns;
in {
  options.${namespace}.services.duckdns = {
    enable = mkEnableOption "DuckDNS, the dynamic dns service. Will periodically refresh your IP.";
    sopsFile = mkOpt types.path null "The location of the sops secret file for the DuckDNS service.";
    sopsFormat = mkOpt types.str null "The format of the sops secret file for the DuckDNS service.";
  };

  config = mkIf cfg.enable {
    sops.secrets.duckdns = {
      sopsFile = cfg.sopsFile;
      format = cfg.sopsFormat;
    };

    virtualisation.oci-containers.containers.duckdns = {
      image = "lscr.io/linuxserver/duckdns:latest";
      autoStart = true;
      hostname = config.networking.hostName;
      environmentFiles = [
        config.sops.secrets.duckdns.path
      ];
    };
  };
}
