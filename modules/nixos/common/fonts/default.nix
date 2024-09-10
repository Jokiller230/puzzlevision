{
  lib,
  pkgs,
  namespace,
  config,
  options,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.fonts;
in {
  options.${namespace}.common.fonts = {
    enable = mkEnableOption "Enable system font management";
    #fonts = mkOption {
    #  type = types.package;
    #  default = noto-fonts;
    #  example = [ noto-fonts noto-fonts-emoji ];
    #  description = "Install additional font packages";
    #};
  };

  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true"; # Enable icons in tooling (requires nerdfonts)
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nerdfonts
    ]; # ++ cfg.fonts;
  };
}
