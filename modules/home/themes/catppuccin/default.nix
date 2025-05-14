{
  lib,
  self,
  pkgs,
  config,
  osConfig,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf;
  inherit (self.lib) mkOpt;

  palette = (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${config.catppuccin.flavor}.colors;

  cfg = config.${namespace}.themes.catppuccin;
in {
  options.${namespace}.themes.catppuccin = {
    enable = mkEnableOption "the Catppuccin theme, globally.";
    accent = mkOpt types.str "blue" "The accent colour to use.";
    flavor = mkOpt types.str "macchiato" "The flavor to use.";
    palette = mkOpt (lib.types.attrsOf lib.types.raw) palette "a reference to the current active Catppuccin palette.";
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

    ${namespace}.themes.catppuccin = {
      gtk.enable = mkIf osConfig.${namespace}.desktop.gnome.enable true;
    };
  };
}
