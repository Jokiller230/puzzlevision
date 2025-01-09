{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.common.networking;
in {
  options.${namespace}.common.networking = {
    enable = mkEnableOption "Whether to enable networking through NetworkManager.";
  };

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
    };
  };
}
