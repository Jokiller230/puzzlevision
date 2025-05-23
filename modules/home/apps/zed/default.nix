{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (self) namespace;

  cfg = config.${namespace}.apps.zed;
in {
  options.${namespace}.apps.zed = {
    enable = mkEnableOption "zed, the graphical editor from the future";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        ### Theme settings
        icon_theme = mkForce {
          dark = mkIf config.catppuccin.enable "Catppuccin Macchiato";
          light = mkIf config.catppuccin.enable "Catppuccin Latte";
        };

        theme = mkForce {
          dark = mkIf config.catppuccin.enable "Catppuccin Macchiato (blue)";
          light = mkIf config.catppuccin.enable "Catppuccin Latte (blue)";
        };

        ### Disable telemetry
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        ### Remove useless features and stuff
        show_call_status_icon = false;
        agent.button = false;
        collaboration_panel.button = false;
        chat_panel.button = false;

        features = {
          inline_completion_provider = "none";
          edit_prediction_provider = "none";
          copilot = false;
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
        tab_size = 2;
        soft_wrap = "preferred_line_length";

        ### Language specific configurations
        languages = {
          Nix = {
            language_servers = ["nixd" "!nil"];
            formatter = {
              external = {
                command = "alejandra";
                arguments = ["--quiet"];
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
          ejs = true;
          scss = true;

          # Languages
          nix = true;
          php = true;
          sql = true;
          toml = true;
          pylsp = true; # Python
          fish = true;

          # Docker
          dockerfile = true;
          docker-compose = true;

          # Theming
          catppuccin = mkIf config.catppuccin.enable true;
          catppuccin-icons = mkIf config.catppuccin.enable true;

          # Other
          discord-presence = true;
          git-firefly = true;
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

      extraPackages = with pkgs; [
        ### Nix
        nixd
        alejandra

        ### Python
        python3Packages.python-lsp-server
      ];
    };
  };
}
