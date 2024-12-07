{
  lib,
  pkgs,
  namespace,
  ...
}: with lib; with lib.${namespace};
{
  imports = [
    ./apps/gnome.nix
    ./apps/vscodium.nix
  ];

  themes.catppuccin.gtk.enable = true;

  # Flatpak configuration.
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [];
  };

  # Declare user packages.
  home.packages = with pkgs; [
    ### General
    qflipper
    wineWowPackages.waylandFull
    vesktop
    lunar-client
    steam
    g4music
    bitwarden-desktop

    ### Development
    avra
    avrdude
    jetbrains.phpstorm
    jetbrains.pycharm-community
    git
    nodejs_22
    bun
    devenv
    python39
    nil
    zed-editor

    ### Rust development specific
    rustup
    gcc

    ### Work
    teams-for-linux
    enpass

    ### Notes & Organisation
    obsidian

    ### Virtual Reality
    sidequest
  ];

  home.stateVersion = "24.05";
}
