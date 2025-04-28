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
      system = {
        networking.enable = true;
        grub.enable = true;
        shell.enable = true;
        locale.enable = true;
        fonts.enable = true;
        bluetooth.enable = true;
        audio.enable = true;
        kernel.enable = true;
        nix = {
          enable = true;
          use-lix = true;
        };
      };

      # Services
      services.docker.enable = true;

      # Desktop environment
      desktop.gnome.enable = true;
    };

    time.timeZone = mkDefault "Europe/Berlin";
  };
}
