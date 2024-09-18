{
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
    "org/gnome/shell/extensions/user-theme" = {
      name = "Colloid-Dark-Catppuccin";
    };

    "org/gnome/desktop/background" = {
      picture-uri = lib.snowfall.fs.get-file "resources/wallpapers/catppuccin_blue_cat.png";
      picture-uri-dark = lib.snowfall.fs.get-file "resources/wallpapers/catppuccin_blue_cat.png";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "catppuccin-macchiato-blue-cursors";
    };
  };
}
