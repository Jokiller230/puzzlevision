{
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # wakatime.vscode-wakatime # Wakatime for coding statistics
      vue.volar # Vue support
      svelte.svelte-vscode # Svelte support
      pkief.material-icon-theme # Material icons
      prisma.prisma
      ms-python.vscode-pylance # Python support
      ms-dotnettools.csharp # CSharp support
      mikestead.dotenv # Improved dotenv support
      catppuccin.catppuccin-vsc # Catppuccin theme
      jnoortheen.nix-ide # Nix language support
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "workbench.colorTheme" = "Catppuccin Macchiato";
    };
  };
}