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
    ./apps/ghostty
    ./apps/zed

    ./desktop/gnome
  ];

  puzzlevision = {
    themes.catppuccin.enable = true;
    cli.direnv.enable = true;
  };

  sops.secrets.wakatime-cfg = {
    format = "binary";
    sopsFile = ./secrets/wakatime.cfg;
    path = "${config.home.homeDirectory}/.wakatime.cfg";
  };

  home.packages = with pkgs; [
    ## GENERAL
    enpass
    pear-desktop
    teams-for-linux

    ## EDITORS
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

  home.stateVersion = "25.11";
}
