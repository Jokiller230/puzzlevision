{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "jo";
    homeDirectory = "/home/jo";
  };

  # home.packages = with pkgs.gnomeExtensions; [
  #   user-themes
  #   dash-to-dock
  #   appindicator
  #   blur-my-shell
  #   rounded-window-corners
  # ];

  # dconf.settings = with lib.hm.gvariant; {
  #   "org/gnome/shell" = {
  #     disable-user-extensions = false;
  #     # enabled-extensions = map (extension: extension.extensionUuid) home.packages;
  #     disabled-extensions = [ ];
  #   };

  #   "org/gnome/shell/extensions/user-theme" = {
  #     name = config.gtk.theme.name;
  #   };

  #   # "org/gnome/shell/extensions/dash-to-dock" = {
  #   #   "appicon-margin" = 0;
  #   #   "appicon-padding" = 6;
  #   #   "tray-padding" = 4;
  #   #   "click-action" = "TOGGLE-SHOWPREVIEW";
  #   #   "dot-position" = "TOP";
  #   #   "dot-style-focused" = "METRO";
  #   #   "dot-style-unfocused" = "DASHES";
  #   #   "group-apps" = true;
  #   #   "isolate-workspaces" = true;
  #   #   "middle-click-action" = "MINIMIZE";
  #   #   "shift-click-action" = "LAUNCH";
  #   #   "scroll-icon-action" = "NOTHING";
  #   #   "scroll-panel-action" = "NOTHING";
  #   #   "stockgs-panelbtn-click-only" = true;
  #   # };

  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #     clock-show-weekday = true;
  #     clock-show-date = true;
  #     clock-show-seconds = false;
  #     enable-hot-corners = false;
  #   };

  #   "org/gnome/desktop/input-sources" = {
  #     sources = [ (mkTuple [ "xkb" "de" ]) ];
  #   };

  #   "org/gnome/shell" = {
  #     favorite-apps = [
  #       "firefox.desktop"
  #       "org.gnome.Nautilus.desktop"
  #     ];
  #   };
  # };

  # gtk = {
  #   enable = true;

  #   theme = {
  #     name = "Adw-gtk3";
  #     package = pkgs.adw-gtk3;
  #   };

  #   cursorTheme = {
  #     name = "Catppuccin-Macchiato-Dark-Cursors";
  #     package = pkgs.catppuccin-cursors.macchiatoRed;
  #     size = 32;
  #   };
  # };

  # home.file.".config/gtk-4.0/gtk.css".source = "${orchis}/share/themes/Orchis-Green-Dark-Compact/gtk-4.0/gtk.css";
  # home.file.".config/gtk-4.0/gtk-dark.css".source = "${orchis}/share/themes/Orchis-Green-Dark-Compact/gtk-4.0/gtk-dark.css";
  # home.file.".config/gtk-4.0/assets" = {
  #   recursive = true;
  #   source = "${orchis}/share/themes/Orchis-Green-Dark-Compact/gtk-4.0/assets";
  # };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
