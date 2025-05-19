{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  puzzlevision = {
    themes.catppuccin = {
      gtk.enable = true;
    };

    apps.zed.enable = true;
  };

  home.file."~/.config/Yubico/u2f_keys".text = ''
    jo:gtKwCQKVw5O4IkWg8J8o7vHIo3hStmOqVcnmk97E335DwHnPUMIDTMnD46qEn/1tucTZlYfGABfzVVG+iYeUOA==,fVRFZb9iBiqjOXvk5Gm9ygO/O4huEUR1Uq3DGBlnS1RtqqK0shif8aOlNLkmn8Xe9+x4HYIeNEX4fc8Z7Y2Hgw==,es256,+presence
  '';

  sops = {
    age.keyFile = "/home/jo/sops-nix/key.txt";
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
    steam
    ungoogled-chromium
    firefox
    thunderbird
    youtube-music
    kando

    ### Development
    #avra
    #avrdude
    jetbrains.phpstorm
    git
    bun
    devenv
    nixd
    deno

    ### GTK Apps
    refine

    ### Work
    teams-for-linux
    enpass

    ### Notes & Organisation
    obsidian
  ];

  home.stateVersion = "25.05";
}
