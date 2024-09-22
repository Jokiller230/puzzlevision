{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs.gnomeExtensions; [
    dash-to-dock
    user-themes
    blur-my-shell
    appindicator
    unite
    color-picker
    clipboard-history
  ];

  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "chromium-browser.desktop"
        "spotify.desktop"
        "phpstorm.desktop"
      ];

      enabled-extensions = [
        pkgs.gnomeExtensions.unite.extensionUuid
        pkgs.gnomeExtensions.color-picker.extensionUuid
        pkgs.gnomeExtensions.clipboard-history.extensionUuid
        pkgs.gnomeExtensions.blur-my-shell.extensionUuid
        pkgs.gnomeExtensions.user-themes.extensionUuid
        pkgs.gnomeExtensions.dash-to-dock.extensionUuid
        pkgs.gnomeExtensions.appindicator.extensionUuid
      ];
    };

    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
    };

    "org/gnome/shell/extensions/unite" = {
      use-activities-text = false;
      extend-left-box = false;
      reduce-panel-spacing = false;
      window-buttons-placement = "first";
      show-legacy-tray = false;
      show-appmenu-button = false;
      show-desktop-name = false;
      enable-titlebar-actions = false;
      restrict-to-primary-screen = true;
      hide-activities-button = "never";
      hide-window-titlebars = "maximized";
      show-window-title = false;
      autofocus-windows = true;
      show-window-buttons = "maximized";
      notifications-position = "right";
      window-buttons-theme = "catppuccin";
    };
  };
}
