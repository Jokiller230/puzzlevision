{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (self) namespace;

  cfg = config.${namespace}.archetypes.workstation;
in {
  options.${namespace}.archetypes.workstation = {
    enable = mkEnableOption "the workstation archetype.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      # Basic system functionality
      system.grub.enable = true;
      system.networking.enable = true;
      system.kernel.enable = true;

      # Services
      services.docker.enable = true;

      # Desktop environment
      desktop.gnome.enable = true;
    };

    time.timeZone = mkDefault "Europe/Berlin";
  };
}
