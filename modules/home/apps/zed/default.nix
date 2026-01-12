{
  lib,
  pkgs,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (self) namespace;

  cfg = config.${namespace}.apps.zed;
in
{
  options.${namespace}.apps.zed = {
    enable = mkEnableOption "Zed, the graphical editor from the future, with a sane base configuration.";
    enable-nix = mkEnableOption "support for the Nix language, based on nixd, in Zed.";
    enable-php = mkEnableOption "support for the PHP language, based on phpactor and pretty-php, in Zed.";
    enable-python = mkEnableOption "support for the Python language, based on pylsp, in Zed.";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        ### Disable telemetry
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        ### Disable collaborative features
        show_call_status_icon = false;
        collaboration_panel.button = false;

        ### Disable AI features
        disable_ai = true;

        ### Theme settings
        icon_theme = mkForce {
          dark = mkIf config.catppuccin.enable "Catppuccin Macchiato";
          light = mkIf config.catppuccin.enable "Catppuccin Latte";
        };

        theme = mkForce {
          dark = mkIf config.catppuccin.enable "Catppuccin Macchiato (blue)";
          light = mkIf config.catppuccin.enable "Catppuccin Latte (blue)";
        };

        ### Formatting and saving settings
        formatter = "language_server";
        format_on_save = "on";
        autosave.after_delay.milliseconds = 0;

        diagnostics.inline.enable = true;

        indent_guides = {
          enable = true;
          coloring = "indent_aware";
        };

        hard_tabs = true;
        tab_size = 4;
        soft_wrap = "preferred_line_length";

        ### Language specific configurations
        languages = {
          Nix = mkIf cfg.enable-nix {
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter = {
              external = {
                command = "nixfmt";
                arguments = [ "--quiet" ];
              };
            };

            tab_size = 2;
          };
          PHP = mkIf cfg.enable-php {
            language_servers = [
              "phpactor"
              "!intelephense"
              "!tailwind-language-server"
            ];
            formatter = {
              external = {
                command = "pretty-php";
              };
            };
          };
        };

        ### Base editor configurations
        auto_update = false;
        auto_install_extension = {
          # Web dev
          html = true;
          svelte = true;
          scss = true;
          oxc = true;

          # Languages
          nix = cfg.enable-nix;
          php = cfg.enable-php;
          sql = true;
          toml = true;
          pylsp = cfg.enable-python; # Python
          fish = true;

          # Docker
          dockerfile = true;
          docker-compose = true;

          # Theming
          catppuccin = config.catppuccin.enable;
          catppuccin-icons = config.catppuccin.enable;

          # Other
          discord-presence = config.programs.nixcord.enable;
          wakatime = true;
        };
      };

      userKeymaps = [
        {
          context = "Editor";
          bindings = {
            # This relies on autosave being active, as it overwrites the default file save keybinding
            ctrl-s = "editor::Format";
          };
        }
      ];

      extraPackages =
        with pkgs;
        [ oxlint ]
        ++ lib.optionals cfg.enable-nix [
          nixd
          nixfmt-rfc-style
        ]
        ++ lib.optionals cfg.enable-python [
          python3Packages.python-lsp-server
        ]
        ++ lib.optionals cfg.enable-php [
          php
          phpPackages.composer
          pretty-php
        ];
    };
  };
}
