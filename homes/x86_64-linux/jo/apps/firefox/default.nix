{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  puzzlevision.apps.firefox = {
    enable = true;
    extensions = [
      "uBlock0@raymondhill.net"
      "ATBC@EasonWong"
      "languagetool-webextension@languagetool.org"
      "firefox-enpass@enpass.io"
      "firefox@tampermonkey.net"
      "wappalyzer@crunchlabz.com"
      "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}"
      "{d49033ac-8969-488c-afb0-5cdb73957f41}"
    ];
  };

  programs.firefox = mkIf config.programs.firefox.enable {
    # Required settings for Onebar
    profiles.default.settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Fixes an issue regarding URL bar content cut-off
      # https://git.gay/freeplay/Firefox-Onebar/issues/30
      "browser.urlbar.trimHttps" = true;
    };
  };

  home.file.".mozilla/firefox/default/chrome/userChrome.css".text =
    mkIf config.programs.firefox.enable ''
      @import "onebar/onebar.css";
    '';

  home.file.".mozilla/firefox/default/chrome/onebar/onebar.css".source =
    mkIf config.programs.firefox.enable ./onebar.css;
}
