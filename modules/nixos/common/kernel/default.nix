{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.kernel;
in {
  options.${namespace}.common.kernel = {
    enable = mkEnableOption "Modify the standard kernel settings";
    version = mkOption {
      type = types.str;
      default = "linuxPackages_latest";
      example = "linuxPackages_latest";
      description = "Set the kernel version to be used by your system";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.${cfg.version};
  };
}
