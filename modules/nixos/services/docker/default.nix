{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (self) namespace;

  cfg = config.${namespace}.services.docker;
in
{
  options.${namespace}.services.docker = {
    enable = mkEnableOption "the docker service.";
  };

  config = mkIf cfg.enable {
    # Enable docker
    virtualisation = {
      docker.enable = true;
      oci-containers.backend = "docker";
    };
  };
}
