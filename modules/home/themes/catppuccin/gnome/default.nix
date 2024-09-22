{
  lib,
  namespace,
  config,
  pkgs,
  ...
}: with lib; with lib.${namespace};
let
  # Stolen from Oli @ git.gay, basically just themes default libadwaita components.
  css = pkgs.writeTextFile {
    name = "gtk-css";
    text = ''
      @define-color accent_color ${config.palette.blue.hex};
      @define-color accent_bg_color ${config.palette.blue.hex};
      @define-color accent_fg_color ${config.palette.base.hex};
      @define-color destructive_color ${config.palette.red.hex};
      @define-color destructive_bg_color ${config.palette.red.hex};
      @define-color destructive_fg_color ${config.palette.base.hex};
      @define-color success_color ${config.palette.green.hex};
      @define-color success_bg_color ${config.palette.green.hex};
      @define-color success_fg_color ${config.palette.base.hex};
      @define-color warning_color ${config.palette.mauve.hex};
      @define-color warning_bg_color ${config.palette.mauve.hex};
      @define-color warning_fg_color ${config.palette.base.hex};
      @define-color error_color ${config.palette.red.hex};
      @define-color error_bg_color ${config.palette.red.hex};
      @define-color error_fg_color ${config.palette.base.hex};
      @define-color window_bg_color ${config.palette.base.hex};
      @define-color window_fg_color ${config.palette.text.hex};
      @define-color view_bg_color ${config.palette.base.hex};
      @define-color view_fg_color ${config.palette.text.hex};
      @define-color headerbar_bg_color ${config.palette.mantle.hex};
      @define-color headerbar_fg_color ${config.palette.text.hex};
      @define-color headerbar_border_color rgba(${builtins.toString config.palette.base.rgb.r}, ${builtins.toString config.palette.base.rgb.g}, ${builtins.toString config.palette.base.rgb.b}, 0.7);
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
      @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);
      @define-color sidebar_bg_color ${config.palette.mantle.hex};
      @define-color sidebar_fg_color ${config.palette.text.hex};
      @define-color sidebar_backdrop_color @window_bg_color;
      @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
      @define-color secondary_sidebar_bg_color @sidebar_bg_color;
      @define-color secondary_sidebar_fg_color @sidebar_fg_color;
      @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
      @define-color secondary_sidebar_shade_color @sidebar_shade_color;
      @define-color card_bg_color ${config.palette.mantle.hex};
      @define-color card_fg_color ${config.palette.text.hex};
      @define-color card_shade_color rgba(0, 0, 0, 0.07);
      @define-color dialog_bg_color ${config.palette.mantle.hex};
      @define-color dialog_fg_color ${config.palette.text.hex};
      @define-color popover_bg_color ${config.palette.mantle.hex};
      @define-color popover_fg_color ${config.palette.text.hex};
      @define-color popover_shade_color rgba(0, 0, 0, 0.07);
      @define-color shade_color rgba(0, 0, 0, 0.07);
      @define-color scrollbar_outline_color ${config.palette.surface0.hex};
      @define-color blue_1 ${config.palette.blue.hex};
      @define-color blue_2 ${config.palette.blue.hex};
      @define-color blue_3 ${config.palette.blue.hex};
      @define-color blue_4 ${config.palette.blue.hex};
      @define-color blue_5 ${config.palette.blue.hex};
      @define-color green_1 ${config.palette.green.hex};
      @define-color green_2 ${config.palette.green.hex};
      @define-color green_3 ${config.palette.green.hex};
      @define-color green_4 ${config.palette.green.hex};
      @define-color green_5 ${config.palette.green.hex};
      @define-color yellow_1 ${config.palette.yellow.hex};
      @define-color yellow_2 ${config.palette.yellow.hex};
      @define-color yellow_3 ${config.palette.yellow.hex};
      @define-color yellow_4 ${config.palette.yellow.hex};
      @define-color yellow_5 ${config.palette.yellow.hex};
      @define-color orange_1 ${config.palette.peach.hex};
      @define-color orange_2 ${config.palette.peach.hex};
      @define-color orange_3 ${config.palette.peach.hex};
      @define-color orange_4 ${config.palette.peach.hex};
      @define-color orange_5 ${config.palette.peach.hex};
      @define-color red_1 ${config.palette.red.hex};
      @define-color red_2 ${config.palette.red.hex};
      @define-color red_3 ${config.palette.red.hex};
      @define-color red_4 ${config.palette.red.hex};
      @define-color red_5 ${config.palette.red.hex};
      @define-color purple_1 ${config.palette.mauve.hex};
      @define-color purple_2 ${config.palette.mauve.hex};
      @define-color purple_3 ${config.palette.mauve.hex};
      @define-color purple_4 ${config.palette.mauve.hex};
      @define-color purple_5 ${config.palette.mauve.hex};
      @define-color brown_1 ${config.palette.flamingo.hex};
      @define-color brown_2 ${config.palette.flamingo.hex};
      @define-color brown_3 ${config.palette.flamingo.hex};
      @define-color brown_4 ${config.palette.flamingo.hex};
      @define-color brown_5 ${config.palette.flamingo.hex};
      @define-color light_1 ${config.palette.mantle.hex};
      @define-color light_2 ${config.palette.mantle.hex};
      @define-color light_3 ${config.palette.mantle.hex};
      @define-color light_4 ${config.palette.mantle.hex};
      @define-color light_5 ${config.palette.mantle.hex};
      @define-color dark_1 ${config.palette.mantle.hex};
      @define-color dark_2 ${config.palette.mantle.hex};
      @define-color dark_3 ${config.palette.mantle.hex};
      @define-color dark_4 ${config.palette.mantle.hex};
      @define-color dark_5 ${config.palette.mantle.hex};
    '';
  };

  cfg = config.themes.catppuccin.gtk;
in
{
  options.themes.catppuccin.gtk = { enable = mkEnableOption "Enable the Catppuccin theme for GTK"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (colloid-gtk-theme.override {
        themeVariants = ["default"];
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
        tweaks = ["catppuccin"];
      })
    ];

    gtk = {
      enable = true;

      font = {
        name = "Ubuntu";
        size = 12;
        package = pkgs.ubuntu-sans;
      };

      catppuccin = {
        icon = {
          enable = true;
          accent = "blue";
          flavor = "macchiato";
        };
      };

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      gtk3 = {
        extraCss = ''@import url("${css}");'';
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      gtk4 = {
        extraCss = ''@import url("${css}");'';
      };
    };

    dconf.settings = {
      "org/gnome/shell/extensions/user-theme" = {
        name = "Colloid-Dark-Catppuccin";
      };

      "org/gnome/desktop/background" = {
        picture-uri = lib.snowfall.fs.get-file "resources/wallpapers/blossoms.png";
        picture-uri-dark = lib.snowfall.fs.get-file "resources/wallpapers/blossoms.png";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "catppuccin-macchiato-blue-cursors";
      };
    };
  };
}
