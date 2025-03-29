{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  puzzlevision = {
    themes.catppuccin = {
      gtk.enable = true;
    };

    apps.nushell.enable = false;
    apps.vscodium.enable = true;
    apps.zed.enable = true;
  };

  home.file."~/.local/share/fonts/Unknown\ Vendor/qwerasd205/AnnotationMono/AnnotationMono-VF.ttf".source = lib.snowfall.fs.get-file "resources/fonts/AnnotationMono/variable/AnnotationMono-VF.ttf";

  home.file."~/.config/Yubico/u2f_keys".text = ''
    jo:gtKwCQKVw5O4IkWg8J8o7vHIo3hStmOqVcnmk97E335DwHnPUMIDTMnD46qEn/1tucTZlYfGABfzVVG+iYeUOA==,fVRFZb9iBiqjOXvk5Gm9ygO/O4huEUR1Uq3DGBlnS1RtqqK0shif8aOlNLkmn8Xe9+x4HYIeNEX4fc8Z7Y2Hgw==,es256,+presence
  '';

  sops = {
    age.keyFile = "/home/jo/sops-nix/key.txt";
  };

  # Flatpak configuration.
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [];
  };

  programs = {
    # TODO: look at git-sync for syncing stuff like obsidian vaults.
    git-credential-oauth.enable = true;

    nixcord = {
      enable = true;
      config = {
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-macchiato-blue.theme.css"
        ];
        frameless = true;
      };
    };
  };

  # Declare user packages.
  home.packages = with pkgs; [
    ### General
    qflipper
    labymod-launcher
    steam
    youtube-music
    ungoogled-chromium
    firefox

    ### Development
    #avra
    #avrdude
    jetbrains.phpstorm
    git
    bun
    devenv
    python39
    nixd
    bruno
    deno

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
