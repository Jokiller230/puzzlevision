{
  lib,
  pkgs,
  host,
  config,
  osConfig,
  namespace,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${host}.desktop.gnome;
in
{
  options.${host}.desktop.gnome = with types; {
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.gnomeExtensions; [ dash-to-dock user-themes blur-my-shell appindicator unite color-picker clipboard-history ];
      example = [ dash-to-dock blur-my-shell ];
      description = "Specify gnome extensions to install.";
    };
    favorite-apps = mkOption {
      type = listOf string;
      default = ["org.gnome.Nautilus.desktop" "obsidian.desktop" "zen.desktop" "dev.zed.Zed.desktop"];
      example = ["org.gnome.Nautilus.desktop" "obsidian.desktop"];
      description = "Specify your favorite apps (sorted left to right)";
    };
  };

  config = mkIf osConfig.${namespace}.desktop.gnome.enable {
    home.packages = cfg.extensions;

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = cfg.favorite-apps;
        enabled-extensions = forEach cfg.extensions (x: x.extensionUuid);
        disabled-extensions = []; # Make sure none of our extensions are disabled on system rebuild
      };
    };
  };
}
