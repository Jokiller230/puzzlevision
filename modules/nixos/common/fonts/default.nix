{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.fonts;
in {
  options.${namespace}.common.fonts = with types; {
    enable = mkEnableOption "Enable system font management";
    fonts = mkOption {
      type = listOf package;
      default = with pkgs; [ noto-fonts noto-fonts-cjk-sans noto-fonts-cjk-serif noto-fonts-emoji nerd-fonts.bigblue-terminal nerd-fonts.zed-mono monocraft ];
      example = [ noto-fonts noto-fonts-emoji ];
      description = "Install additional font packages";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true"; # Enable icons in tooling (requires nerdfonts)
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts.packages = cfg.fonts;
  };
}
