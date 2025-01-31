{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.tools.cachix;
in {
  options.${namespace}.tools.cachix = { enable = mkEnableOption "Enable the cachix binary cache service on your system."; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cachix ];
  };
}
