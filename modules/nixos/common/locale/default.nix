{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.locale;
in {
  options.${namespace}.common.locale = {
    enable = mkEnableOption "whether to enable common locale tweaks";

    language = mkOption {
      type = types.str;
      default = "en_US";
      example = "en_US";
      description = "Sets the language for most text, doesn't include monetary or measurement settings";
    };

    country = mkOption {
      type = types.str;
      default = "de_DE";
      example = "de_DE";
      description = "Sets the language used for monetary or measurement settings (USD vs Euro, etc...)";
    };

    keymap = mkOption {
      type = types.str;
      default = "de";
      example = "de";
      description = "Sets the keymap to be used by the system";
    };
  };

  config = mkIf cfg.enable {
    # Internationalisation properties.
    i18n.defaultLocale = "${cfg.language}.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${cfg.country}.UTF-8";
      LC_IDENTIFICATION = "${cfg.country}.UTF-8";
      LC_MEASUREMENT = "${cfg.country}.UTF-8";
      LC_MONETARY = "${cfg.country}.UTF-8";
      LC_NAME = "${cfg.country}.UTF-8";
      LC_NUMERIC = "${cfg.country}.UTF-8";
      LC_PAPER = "${cfg.country}.UTF-8";
      LC_TELEPHONE = "${cfg.country}.UTF-8";
      LC_TIME = "${cfg.country}.UTF-8";
    };

    # Set console keymap.
    console.keyMap = cfg.keymap;
    services.xserver = {
      xkb.layout = cfg.keymap;
    };
  };
}
