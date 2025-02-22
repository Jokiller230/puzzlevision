{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption;
  palette = (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${config.catppuccin.flavor}.colors;
in {
  options.palette = mkOption {type = lib.types.attrsOf lib.types.raw;};

  config = {
    inherit palette;
  };
}
