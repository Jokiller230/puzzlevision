{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.apps.vscodium;
in {
  options.${namespace}.apps.vscodium = {
    enable = mkEnableOption "vscodium";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;

      extensions = with pkgs; [
        ### Theming
        vscode-extensions.pkief.material-icon-theme
        vscode-extensions.catppuccin.catppuccin-vsc

        ### General
        vscode-extensions.usernamehw.errorlens
        vscode-extensions.leonardssh.vscord
        vscode-extensions.davidlday.languagetool-linter
        vscode-extensions.christian-kohler.path-intellisense
        vscode-extensions.wakatime.vscode-wakatime

        ### Language specific
        # Nushell
        vscode-extensions.thenuprojectcontributors.vscode-nushell-lang

        # Nix
        vscode-extensions.kamadorueda.alejandra
        vscode-extensions.jnoortheen.nix-ide

        # Env
        vscode-extensions.irongeek.vscode-env

        # Deno (JavaScript)
        vscode-extensions.denoland.vscode-deno
      ];

      userSettings = {
        "files.autoSave" = "on";
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "window.titleBarStyle" = "custom";

        "[nix]" = {
          "editor.tabSize" = 2;
          "formatterPath" = "alejandra";

          "enableLanguageServer" = true;
          "serverPath" = "nixd";
          "serverSettings" = {
            "nixd" = {
              "formatting.command" = ["alejandra"];
            };
          };
        };
      };
    };
  };
}
