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
  cfg = config.${namespace}.common.kernel;
in {
  options.${namespace}.common.kernel = {
    enable = mkEnableOption "Modify the standard kernel settings";
    version = mkOption {
      type = lib.types.str;
      default = "latest";
      example = "latest";
      description = "Set the kernel version to be used by your system"
    };
  };

  config = mkIf cfg.enable {
    kernelPackages = pkgs.linuxPackages_${cfg.version};
  };
}
