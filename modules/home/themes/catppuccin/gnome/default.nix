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
        flavor = "frappe";
      };
    };

    theme = {
      name = "Colloid-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = ["default"];
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
        tweaks = ["catppuccin"];
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = lib.snowfall.fs.get-file "resources/wallpapers/pond_sidewalk_dusk.jpg";
      picture-uri-dark = lib.snowfall.fs.get-file "resources/wallpapers/pond_sidewalk_dusk.jpg";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Colloid-Dark-Catppuccin";
    };
  };
}