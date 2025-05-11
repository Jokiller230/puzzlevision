{
  lib,
  self,
  config,
  osConfig,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.themes.catppuccin;
in {
  options.${namespace}.themes.catppuccin = {
    enable = mkEnableOption "the Catppuccin theme, globally.";
    accent = mkOpt types.str "blue" "The accent colour to use.";
    flavor = mkOpt types.str "macchiato" "The flavor to use.";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = cfg.accent;
      flavor = cfg.flavor;

      cursors.enable = true;
      cursors.accent = cfg.accent;
      cursors.flavor = cfg.flavor;
    };

    ${namespace}.themes.catppuccin.gtk.enable = mkIf osConfig.${namespace}.desktop.gnome.enable true;
  };
}
