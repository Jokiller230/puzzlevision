{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.desktop.plasma;
in {
  options.${namespace}.desktop.plasma = { enable = mkEnableOption "Whether to enable the KDE Plasma desktop environment"; };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;

    programs.kdeconnect.enable = true;
  };
}