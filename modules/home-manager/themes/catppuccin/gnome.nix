{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
  };

  dconf.settings = {
    # ---------------------- Theming
    "org/gnome/desktop/background" = {
      picture-uri = "${outputs.resources.wallpapers}/animals_at_campfire.jpg";
      picture-uri-dark = "${outputs.resources.wallpapers}/animals_at_campfire.jpg";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Frappe-Standard-Blue-Dark";
    };
    # ---------------------- Theming END
  };
}