{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.themes.catppuccin.black-box;
in {
  options.${namespace}.themes.catppuccin.black-box = {
    enable = mkEnableOption "Whether to enable the catppuccin theme for black-box.";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "com/raggesilver/BlackBox" = {
        theme-dark = "Catppuccin Macchiato";
      };
    };
  };
}
