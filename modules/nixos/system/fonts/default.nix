{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (self) namespace;

  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with lib.types; {
    enable = mkEnableOption "system font management";
    fonts = mkOption {
      type = listOf package;
      default = with pkgs; [
        corefonts

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        inter

        nerd-fonts.zed-mono
        monocraft

        noto-fonts-emoji
        material-icons
        material-design-icons
      ];
      example = [noto-fonts noto-fonts-emoji];
      description = "Install additional font packages";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [font-manager];

    fonts.packages = cfg.fonts;
  };
}
