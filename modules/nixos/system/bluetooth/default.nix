{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.system.bluetooth;
in {
  options.${namespace}.system.bluetooth = {
    enable = mkEnableOption "bluetooth support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [bluez];

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
          Disable = "Handsfree";
        };
      };
    };
  };
}
