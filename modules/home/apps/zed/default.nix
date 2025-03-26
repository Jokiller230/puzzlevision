{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.apps.zed;
in {
  options.${namespace}.apps.zed = {
    enable = mkEnableOption "zed, the graphical editor from the future";
  };

  config = mkIf cfg.enable {
    sops.secrets.wakatime-cfg = {
      format = "binary";
      sopsFile = lib.snowfall.fs.get-file "secrets/wakatime.cfg";
      path = "/home/jo/.wakatime.cfg";
    };

    home.packages = with pkgs; [
      alejandra
    ];

    programs.zed-editor = {
      enable = true;
      extensions = ["nix" "catppuccin" "wakatime" "discord_presence" "deno"];

      userSettings = {
        icon_theme = "Catppuccin Macchiato";
        theme = {
          dark = "Catppuccin Macchiato (blue)";
          light = "Catppuccin Macchiato (blue)";
        };

        ### Disable telemetry
        telemetry = {
          metrics = false;
        };

        ### Disable certain AI features
        features = {
          copilot = false;
        };

        ### Language specific configurations
        languages = {
          ### Nix language
          Nix = {
            language_servers = [ "nixd" "!nil" ];
          };
        };

        ### LSP configurations
        lsp = {
          nixd = {
            initialization_options = {
              formatting = {
                command = ["alejandra" "--quiet" "--"];
              };
            };
          };
        };
      };

      extraPackages = with pkgs; [ nixd ];
    };
  };
}
