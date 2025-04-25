{
  lib,
  pkgs,
  self,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkOption;
  inherit (self) namespace;

  cfg = config.${namespace}.desktop.gnome;
in {
  options.${namespace}.desktop.gnome = with lib.types; {
    enabled-extensions = mkOption {
      type = listOf package;
      default = with pkgs.gnomeExtensions; [dash-to-dock user-themes blur-my-shell appindicator unite color-picker clipboard-history];
      example = [dash-to-dock blur-my-shell];
      description = "Specify gnome extensions to install.";
    };
  };

  config = mkIf osConfig.${namespace}.desktop.gnome.enable {
    home.packages = cfg.enabled-extensions;

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = lib.forEach cfg.enabled-extensions (x: x.extensionUuid);
        disabled-extensions = []; # Make sure none of our extensions are disabled on system rebuild
      };
    };
  };
}
