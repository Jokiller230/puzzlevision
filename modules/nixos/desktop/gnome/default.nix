{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = {enable = mkEnableOption "Enable the gnome desktop environment ${namespace}";};

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
