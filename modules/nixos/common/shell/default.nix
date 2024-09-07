{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.shell;
in {
  options.${namespace}.common.shell = {
    enable = mkEnableOption "Modify the standard shell options";
    package = mkOption {
      type = types.str;
      default = "fish";
      example = "fish";
      description = "Select an appropriate shell environment (bash, fish, zsh...)";
    };
  };

  config = mkIf cfg.enable {
    environment.shells = with pkgs; [ ${cfg.package} ];
    users.defaultUserShell = pkgs.${cfg.package};
    programs.${cfg.package}.enable = true;
  };
}
