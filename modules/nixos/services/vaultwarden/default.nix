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

  cfg = config.${namespace}.services.vaultwarden;
in
{
  options.${namespace}.services.vaultwarden = {
    enable = mkEnableOption "Vaultwarden, a self-hostable password manager.";
    sopsFile =
      mkOpt types.path null
        "The location of the sops secret file for the Vaultwarden service.";
    sopsFormat = mkOpt types.str null "The format of the sops secret file for the Vaultwarden service.";
    subdomain =
      mkOpt types.str "vault"
        "The subdomain, of the system domain, the service should be exposed on.";
  };

  config = mkIf cfg.enable {
    sops.secrets."services/vaultwarden" = {
      sopsFile = cfg.sopsFile;
      format = cfg.sopsFormat;
    };

    # Ensure directories exist before OCI container is launched.
    systemd.tmpfiles.rules = [
      "d /var/lib/containers/vaultwarden/data 0700 root root -"
    ];

    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server";
      autoStart = true;
      hostname = config.networking.hostName;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vaultwarden.entrypoints" = "websecure";
        "traefik.http.routers.vaultwarden.rule" = "Host(`${cfg.subdomain}.${
          config.${namespace}.services.domain
        }`)";
      };
      volumes = [
        "/var/lib/containers/vaultwarden/data:/data:rw"
      ];
      environmentFiles = [
        config.sops.secrets."services/vaultwarden".path
      ];
      extraOptions = [ "--network=proxy" ];
    };
  };
}
