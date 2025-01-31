{
  lib,
  namespace,
  config,
  host,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.vaultwarden;
in {
  options.${namespace}.services.vaultwarden = { enable = mkEnableOption "Enable Vaultwarden, a self-hostable password manager."; };

  config = mkIf cfg.enable {
    sops.secrets.vaultwarden = {
      sopsFile = lib.snowfall.fs.get-file "secrets/vaultwarden.service.env";
      format = "dotenv";
    };

    # Ensure directories exists before OCI container is launched.
    systemd.tmpfiles.rules = [
      "d /var/lib/containers/vaultwarden/data 0700 root root -"
    ];

    # "Inspired" by BreakingTV @ github.com
    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server";
      autoStart = true;
      hostname = host;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vaultwarden.entrypoints" = "websecure";
        "traefik.http.routers.vaultwarden.rule" = "Host(`vault.thevoid.cafe`)";
      };
      volumes = [
        "/var/lib/containers/vaultwarden/data:/data:rw"
      ];
      environmentFiles = [
        config.sops.secrets.vaultwarden.path
      ];
      extraOptions = ["--network=proxy"];
    };
  };
}
