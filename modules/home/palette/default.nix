{
  lib,
  namespace,
  config,
  pkgs,
  ...
}: with lib; with lib.${namespace};
let
  palette = (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json")).${config.catppuccin.flavor}.colors;
in
{
  options.palette = mkOption { type = types.attrsOf types.raw; };

  config = {
    inherit palette;
  };
}
