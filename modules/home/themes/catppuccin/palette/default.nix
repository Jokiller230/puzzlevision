{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkOption mkIf;
  palette = (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${config.catppuccin.flavor}.colors;
in {
  options.${namespace}.themes.catppuccin.palette = mkOption {type = lib.types.attrsOf lib.types.raw;};

  config.${namespace}.themes.catppuccin.palette = mkIf config.${namespace}.themes.catppuccin.enable palette;
}
