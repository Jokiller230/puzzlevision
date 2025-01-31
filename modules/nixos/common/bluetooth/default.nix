{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.common.bluetooth;
in {
  options.${namespace}.common.bluetooth = { enable = mkEnableOption "Enable bluetooth support on your current system"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bluez ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;

      settings = {
        General = {
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true";
          KernelExperimental = "true";
          Disable= "Handsfree";
        };
      };
    };
  };
}
