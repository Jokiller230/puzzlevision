{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./apps/discord
    ./apps/youtube-music
  ];

  puzzlevision = {
    themes.catppuccin.enable = true;
    apps.zed.enable = true;
    apps.firefox = {
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
  };

  sops.secrets.wakatime-cfg = {
    format = "binary";
    sopsFile = ./secrets/wakatime.cfg;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  home.packages = with pkgs; [
    ## GENERAL
    ghostty
    teams-for-linux
    enpass

    ## WEB
    ungoogled-chromium

    ## EDITORS
    apostrophe
    jetbrains.phpstorm
    arduino-ide
    obsidian

    ## RUNTIMES and CLIs for development
    bun
    git
    attic-client
  ];

  home.stateVersion = "25.05";
}
