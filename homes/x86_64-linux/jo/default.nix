{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./apps/discord
    ./apps/firefox
    ./apps/vicinae
    ./apps/packettracer

    ./desktop/gnome
  ];

  puzzlevision = {
    themes.catppuccin.enable = true;
    apps = {
      zed.enable = true;
    };

    cli = {
      direnv.enable = true;
    };
  };

  programs = {
    ghostty.enable = true;
  };

  sops.secrets.wakatime-cfg = {
    format = "binary";
    sopsFile = ./secrets/wakatime.cfg;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  home.packages = with pkgs; [
    ## GENERAL
    teams-for-linux
    enpass
    youtube-music

    ## EDITORS
    apostrophe
    jetbrains.phpstorm
    obsidian

    ## RUNTIMES and CLIs for development
    bun
    git
    git-credential-oauth
    attic-client

    ## PHP/Shopware
    shopware-cli
  ];

  home.stateVersion = "25.05";
}
