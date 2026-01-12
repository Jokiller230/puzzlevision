{
  pkgs,
  ...
}:
{
  puzzlevision.desktop.gnome = {
    enabled-extensions = with pkgs.gnomeExtensions; [
      user-themes
      blur-my-shell
      appindicator
      unite
      color-picker
      vicinae
    ];

    favorite-apps = [
      "org.gnome.Nautilus.desktop"
      "obsidian.desktop"
      "firefox.desktop"
      "dev.zed.Zed.desktop"
    ];

    wallpaper = ../wallpapers/macchiato-waves.jpg;
  };

  dconf.settings = {
    "org/gnome/shell/extensions/unite" = {
      show-window-buttons = "never";
      hide-window-titlebars = "maximized";

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
}
