{
  osConfig,
  config,
  self,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (self) namespace;

  cfg = config.${namespace}.cli.direnv;
in
{

  options.${namespace}.cli.direnv = {
    enable = mkEnableOption "enable direnv support";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableFishIntegration = mkIf (osConfig.${namespace}.users.defaultUserShell == pkgs.fish);
    };
  };
}
