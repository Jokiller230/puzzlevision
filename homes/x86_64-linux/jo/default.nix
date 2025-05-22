{
  pkgs,
  config,
  ...
}: {
  puzzlevision = {
    themes.catppuccin.enable = true;
  };

  sops.secrets.wakatime-cfg = {
    format = "binary";
    sopsFile = ./secrets/wakatime.cfg;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  home.packages = with pkgs; [
    ## GENERAL
    youtube-music
    discord
    ghostty
    teams-for-linux
    enpass

    ## WEB
    firefox
    ungoogled-chromium

    ## EDITORS
    nano
    zed-editor
    apostrophe
    jetbrains.phpstorm
    arduino-ide
    obsidian

    ## RUNTIMES and CLIs for development
    bun
    git
  ];

  home.stateVersion = "25.05";
}
