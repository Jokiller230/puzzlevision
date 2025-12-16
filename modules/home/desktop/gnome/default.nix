{
  lib,
  pkgs,
  self,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = with lib.types; {
    enabled-extensions = mkOpt (listOf package) (with pkgs.gnomeExtensions; [
      user-themes
      blur-my-shell
      appindicator
      unite
      color-picker
      clipboard-history
    ]) "Specify gnome extensions to install.";

    favorite-apps = mkOpt (listOf str) [
      "org.gnome.Nautilus.desktop"
      "firefox.desktop"
    ] "Specify your favorite apps (sorted left to right).";

    wallpaper = mkOpt path ./wallpaper.jpg "Specify the path of your prefered Gnome wallpaper.";
  };

  config = mkIf osConfig.${namespace}.desktop.gnome.enable {
    home.packages = cfg.enabled-extensions;

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = cfg.favorite-apps;
        enabled-extensions = lib.forEach cfg.enabled-extensions (x: x.extensionUuid);
        disabled-extensions = [ ]; # Make sure none of our extensions are disabled on system rebuild
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file://${cfg.wallpaper}";
        picture-uri-dark = "file://${cfg.wallpaper}";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
