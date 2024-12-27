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
      blur-my-shell = {
        enable-blur = mkOpt bool true "Whether to enable blur-my-shell application blur.";
      };
    };
    wallpaper = mkOpt str (builtins.toString ./wallpapers/car-wreck.png) "Specify the path of your prefered Gnome wallpaper.";
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
      "org/gnome/shell/extensions/blur-my-shell/applications" = mkIf cfg.extensions.blur-my-shell.enable-blur {
        blur = true;
        sigma = 30;
        opacity = 230;
        enable-all = true;
      };
      "org/gnome/desktop/background" = {
        picture-uri = cfg.wallpaper;
        picture-uri-dark = cfg.wallpaper;
      };
    };

    home.file.".local/share/themes/catppuccin-macchiato/gnome-shell/gnome-shell.css".text = ''
      #panel {

     /*background-color: #131313;*/

     background-color: rgba(0, 0, 0, 0);

     /*background-color: transparent;*/

     font-weight: bold;

     /*height: 2.2em;*/

     height: 2.3em;

     transition-duration: 250ms;

     /*Custom panel settings */

     /*margin: 5px 35px 0 35px;*/

     margin: 5px 22px 0 22px;

     border-radius: 10px;

     #panel .panel-button {

     background-color: rgba(19, 19, 19, 0.8);

     font-weight: bold;

     /*color: #f2f2f2;*/

     /*color: #131313;*/

     -natural-hpadding: 12px;

     -minimum-hpadding: 6px;

     transition-duration: 150ms;

     border: 0px solid transparent;

     /*border: none;*/

     /*border-radius: 99px;*/

     border-radius: 10px;

     /*margin: 5px;*/

     margin-left: 5px;

     margin-right: 5px;

     #panel .panel-button:active,

     #panel .panel-button:overview,

     #panel .panel-button:focus,

     #panel .panel-button:checked {

     box-shadow: inset 0 0 0 100px rgba(242, 242, 242, 0.2);

     /*background-color: #8c7feb;*/

     background-color: #b299d1;

     /*background-color: #b299d1;*/

     /*color: #8c7feb;*/

     color: #131313;

     /*background-color: rgba(163, 153, 235, 1);*/

     }

     #panel .panel-button:hover {

     box-shadow: inset 0 0 0 100px rgba(242, 242, 242, 0.15);

     background-color: #a399eb;

     color: #131313;

     /*box-shadow: inset 0 0 0 100px rgba(183, 176, 235, 0.15);*/

     }
    '';
  };
}
