{
  lib,
  pkgs,
  namespace,
  config,
  ... 
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.tools.cachix;
in {
  options.${namespace}.tools.cachix = { enable = mkEnableOption "Enable the cachix binary cache service on your system."; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cachix ];
  };
}

