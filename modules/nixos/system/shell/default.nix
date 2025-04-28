{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.system.shell;
in {
  options.${namespace}.system.shell = {
    enable = mkEnableOption "custom user shells.";
    installed = mkOpt types.listOf types.package [pkgs.fish] "List of shell packages to install";
    default = mkOpt types.str "fish" "Set a custom shell as the default for all users.";
  };

  config = mkIf cfg.enable {
    environment.shells = cfg.installed;
    users.defaultUserShell = pkgs.${cfg.shell.type};
    programs.${cfg.shell.type}.enable = true;
  };
}
