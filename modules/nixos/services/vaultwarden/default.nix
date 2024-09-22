{
  lib,
  namespace,
  config,
  host,
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
      hostname = host;
      # Todo: continue writing vaultwarden config
    };
  };
}
