{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # Instance of `pkgs` with overlays and custom packages applied.
  pkgs,
  # All flake inputs.
  inputs,

  # Additional metadata, provided by Snowfall Lib.
  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  # All other arguments come from the home home.
  config,
  ...
}: {
  # Flatpak configuration.
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [
      "com.jeffser.Alpaca"
    ];
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

    ### Development
    avra
    avrdude
    jetbrains.phpstorm
    git
    nodejs_22
    bun
    kitty
    forge-sparks
    devenv

    ### Work
    teams-for-linux
    enpass

    ### Notes & Organisation
    obsidian

    ### Backups & Synchronization
    celeste
  ];

  home.stateVersion = "24.05";
}