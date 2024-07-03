{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  gtk = with pkgs; {
    enable = true;

    font = {
      name = "Cantarell";
      size = 12;
      package = cantarell-fonts;
    };

    catppuccin = {
      icon.enable = true;
      icon.accent = "blue";
      icon.flavor = "frappe";
    };

    theme = {
      name = "Colloid-Dark-Catppuccin";
      package = colloid-gtk-theme.override {
        themeVariants = ["default"];
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
        tweaks = ["catppuccin"];
      };
    };
  };

  dconf.settings = {
    # ---------------------- Theming
    "org/gnome/desktop/background" = {
      picture-uri = "${outputs.resources.wallpapers}/animals_at_campfire.jpg";
      picture-uri-dark = "${outputs.resources.wallpapers}/animals_at_campfire.jpg";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Colloid-Dark-Catppuccin";
    };
    # ---------------------- Theming END
  };
}
