{pkgs, ...}: {
  puzzlevision = {
    themes.catppuccin = {
      gtk.enable = true;
    };

    apps.nushell.enable = false;
    apps.vscodium.enable = true;
  };

  home.file."~/.config/Yubico/u2f_keys".text = ''
    jo:gtKwCQKVw5O4IkWg8J8o7vHIo3hStmOqVcnmk97E335DwHnPUMIDTMnD46qEn/1tucTZlYfGABfzVVG+iYeUOA==,fVRFZb9iBiqjOXvk5Gm9ygO/O4huEUR1Uq3DGBlnS1RtqqK0shif8aOlNLkmn8Xe9+x4HYIeNEX4fc8Z7Y2Hgw==,es256,+presence
  '';

  # Flatpak configuration.
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [];
  };

  # TODO: look at git-sync for syncing stuff like obsidian vaults.
  programs.git-credential-oauth.enable = true;

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
    youtube-music
    ungoogled-chromium
    firefox

    ### Development
    avra
    avrdude
    jetbrains.phpstorm
    git
    bun
    devenv
    python39
    nixd
    bruno
    deno
    carapace

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
