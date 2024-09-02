{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system,
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  config,
  ...
}: {
  gtk = {
    enable = true;

    font = {
      name = "Cantarell";
      size = 12;
      package = pkgs.cantarell-fonts;
    };

    catppuccin = {
      icon = {
        enable = true;
        accent = "blue";
        flavor = "macchiato";
      };
    };

    theme = {
      #name = "Colloid-Dark-Catppuccin";
      #package = pkgs.colloid-gtk-theme.override {
        #themeVariants = ["default"];
        #colorVariants = ["dark"];
        #sizeVariants = ["standard"];
        #tweaks = ["catppuccin"];
      #};

      name = "Graphite-teal-Dark-nord";
      package = pkgs.graphite-gtk-theme.override {
          themeVariants = ["blue" "teal"];
          colorVariants = ["dark"];
          sizeVariants = ["standard"];
          tweaks = ["nord"];
          withGrub = true;
          grubScreens = ["1080p"];
      };
    };
  };

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "Graphite-teal-Dark-nord";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "catppuccin-macchiato-blue-cursors";
    };
  };
}
