{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

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
    "org/gnome/desktop/background" = {
      picture-uri = lib.snowfall.fs.get-file "resources/wallpapers/maid_in_forest_with_lantern.jpg";
      picture-uri-dark = lib.snowfall.fs.get-file "resources/wallpapers/maid_in_forest_with_lantern.jpg";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "spotify.desktop"
        "phpstorm.desktop"
      ];

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "unite@hardpixel.eu"
        "color-picker@tuberry"
        "clipboard-history@alexsaveau.dev"
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
