{
  lib,
  pkgs,
  self,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = with lib.types; {
    enabled-extensions = mkOption {
      type = listOf package;
      default = with pkgs.gnomeExtensions; [user-themes blur-my-shell appindicator unite color-picker clipboard-history];
      example = [dash-to-dock blur-my-shell];
      description = "Specify gnome extensions to install.";
    };
    favorite-apps = mkOption {
      type = listOf str;
      default = ["org.gnome.Nautilus.desktop" "obsidian.desktop" "firefox.desktop" "dev.zed.Zed.desktop"];
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
      blur-my-shell = {
        enable-blur = mkOpt bool false "Whether to enable blur-my-shell application blur.";
      };
    };
    wallpaper = mkOpt str (builtins.toString ../wallpapers/mountain_tower_sunset.jpg) "Specify the path of your prefered Gnome wallpaper.";
  };

  config = mkIf osConfig.${namespace}.desktop.gnome.enable {
    home.packages = cfg.enabled-extensions;

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = cfg.favorite-apps;
        enabled-extensions = lib.forEach cfg.enabled-extensions (x: x.extensionUuid);
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
      "org/gnome/shell/extensions/blur-my-shell/applications" = mkIf cfg.extensions.blur-my-shell.enable-blur {
        blur = true;
        sigma = 30;
        opacity = 230;
        enable-all = true;
        dynamic-opacity = false;
      };
      "org/gnome/desktop/background" = {
        picture-uri = cfg.wallpaper;
        picture-uri-dark = cfg.wallpaper;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
