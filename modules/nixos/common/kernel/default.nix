{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.common.kernel;
in {
  options.${namespace}.common.kernel = {
    enable = mkEnableOption "Modify the standard kernel settings";
    version = mkOpt lib.types.str "linuxPackages_latest" "Set the kernel version to be used by your system";
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.${cfg.version};
  };
}
