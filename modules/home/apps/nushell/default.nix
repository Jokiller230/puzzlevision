{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.apps.nushell;
in {
  options.${namespace}.apps.nushell = {
    enable = mkEnableOption "Whether to enable nushell customization.";
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        extraConfig = ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
          }

          $env.config = {
            completions: {
              case_sensitive: false # case-sensitive completions
              quick: true    # auto complete selections
              partial: true    # partial filling of prompts
              algorithm: "fuzzy"    # prefix or fuzzy
              external: {
                # discover completions using $env.PATH
                enable: true
                # lowering can improve completion performance at the cost of omitting some options
                max_results: 200
                completer: $carapace_completer # check 'carapace_completer'
              }
            }
          }

          $env.PATH = ($env.PATH |
            split row (char esep) |
            prepend /run/wrappers/bin |
            prepend /home/jo/.nix-profile/bin |
            append /usr/bin/env/run/wrappers/bin
          )
        '';
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

    home.packages = with pkgs; [
      carapace
    ];
  };
}
