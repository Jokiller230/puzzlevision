{
  lib,
  pkgs,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.system.kernel;
in
{
  options.${namespace}.system.kernel = {
    enable = mkEnableOption "Modify the standard kernel settings";
    version =
      mkOpt lib.types.str "linuxPackages_latest"
        "Set the kernel version to be used by your system";
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.${cfg.version};
  };
}
