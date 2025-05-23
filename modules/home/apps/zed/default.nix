{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.apps.zed;
in {
  options.${namespace}.apps.zed = {
    enable = mkEnableOption "zed, the graphical editor from the future";
  };

  config = mkIf cfg.enable {
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

        formatter = {
          external = {
            command = "alejandra";
            arguments = ["--quiet"];
            language = ["nix"];
          };
        };

        format_on_save = "on";

        ### Language specific configurations
        languages = {
          ### Nix language
          Nix = {
            language_servers = ["nixd" "!nil"];
          };
        };
      };

      extraPackages = with pkgs; [nixd];
    };
  };
}
