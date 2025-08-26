{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.firefox = mkIf config.programs.firefox.enable {
    # Required settings for Onebar
    profiles.default.settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };

  home.file.".mozilla/firefox/default/chrome/userChrome.css".text =
    mkIf config.programs.firefox.enable ''
      @import "onebar/onebar.css";
    '';

  home.file.".mozilla/firefox/default/chrome/onebar/onebar.css".source =
    mkIf config.programs.firefox.enable ./onebar.css;
}
