{
  lib,
  self,
  pkgs,
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
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1"; # Firefox native Wayland support
      NIXOS_OZONE_WL = "1"; # Native Wayland in Chromium and Electron based applications
    };

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
          use-nixld =  true;
        };
      };

      # Services
      services.docker.enable = true;

      # Desktop environment
      desktop.gnome.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nano
    ];

    time.timeZone = mkDefault "Europe/Berlin";
  };
}
