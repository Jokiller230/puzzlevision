{
  lib,
  namespace,

  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.networking;
in {
  options.${namespace}.common.networking = { enable = mkEnableOption "networking"; };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
