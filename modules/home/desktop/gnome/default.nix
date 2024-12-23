{
  lib,
  pkgs,
  config,
  osConfig,
  namespace,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.desktop.gnome;
in
{
  options.${namespace}.desktop.gnome = with types; {
    enabled-extensions = mkOption {
      type = listOf package;
      default = with pkgs.gnomeExtensions; [ dash-to-dock user-themes blur-my-shell appindicator unite color-picker clipboard-history ];
      example = [ dash-to-dock blur-my-shell ];
      description = "Specify gnome extensions to install.";
    };
    favorite-apps = mkOption {
      type = listOf str;
      default = ["org.gnome.Nautilus.desktop" "obsidian.desktop" "zen.desktop" "dev.zed.Zed.desktop"];
      example = ["org.gnome.Nautilus.desktop" "obsidian.desktop"];
      description = "Specify your favorite apps (sorted left to right).";
    };
    extensions = {
      unite = {
        show-window-buttons = mkOption {
          type = str;
          default = "never";
          example = "never | maximized | tiled | both | always";
          description = "Specify when Unite should display window buttons within the top panel.";
        };
        hide-window-titlebars = mkOption {
          type = str;
          default = "maximized";
          example = "never | maximized | tiled | both | always";
          description = "Specify when Unite should hide window titlebars.";
        };
      };
    };
  };

  config = mkIf osConfig.${namespace}.desktop.gnome.enable {
    home.packages = cfg.enabled-extensions;

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = cfg.favorite-apps;
        enabled-extensions = forEach cfg.enabled-extensions (x: x.extensionUuid);
        disabled-extensions = []; # Make sure none of our extensions are disabled on system rebuild
      };
      "org/gnome/shell/extensions/unite" = mkIf (builtins.elem pkgs.gnomeExtensions.unite cfg.enabled-extensions) {
        show-window-buttons = cfg.extensions.unite.show-window-buttons;
        hide-window-titlebars = cfg.extensions.unite.hide-window-titlebars;

        use-activities-text = false;
        extend-left-box = false;
        reduce-panel-spacing = false;
        show-legacy-tray = false;
        show-appmenu-button = false;
        show-desktop-name = false;
        enable-titlebar-actions = false;
        restrict-to-primary-screen = false;
        hide-activities-button = "never";
        autofocus-windows = true;
        notifications-position = "right";
      };
    };
  };
}
