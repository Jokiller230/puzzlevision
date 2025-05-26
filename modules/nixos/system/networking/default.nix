{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.system.networking;
in
{
  options.${namespace}.system.networking = {
    enable = mkEnableOption "networking.";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
