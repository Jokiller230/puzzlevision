{
  namespace,
  hostname,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.services.vaultwarden;
in {
  options.${namespace}.services.vaultwarden = { enable = mkEnableOption "Enable the Vaultwarden service."; };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server";
      autoStart = true;
      hostname = hostname;
      # Todo: continue writing vaultwarden config
    };

    # Todo: figure out "traefik" as a service and how to configure it per-service
    # Todo: setup age-nix or sops-nix for secret management
  };
}