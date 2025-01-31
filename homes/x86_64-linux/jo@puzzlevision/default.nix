{
  pkgs,
  ...
}:
{
  puzzlevision = {
    themes.catppuccin = {
      gtk.enable = true;
    };
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

  programs = {
      nushell = {
        enable = true;

        # for editing directly to config.nu
        extraConfig = ''
          let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
          }
          $env.config = {
          show_banner: false,
          completions: {
          case_sensitive: false # case-sensitive completions
          quick: true    # set to false to prevent auto-selecting completions
          partial: true    # set to false to prevent partial filling of the prompt
          algorithm: "fuzzy"    # prefix or fuzzy
          external: {
          # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
          # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $carapace_completer # check 'carapace_completer'
            }
          }
          }
          $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
          )
        '';

        shellAliases = {
          vi = "hx";
          vim = "hx";
          nano = "hx";
        };
      };

      carapace.enable = true;
      carapace.enableNushellIntegration = true;

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
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
    nil
    zed-editor
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
