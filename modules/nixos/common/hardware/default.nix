{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.common.hardware;
in {
  options.${namespace}.common.hardware = { enable = mkEnableOption "whether to enable common hardware support"; };

  config = mkIf cfg.enable {
    hardware.sensor.iio.enable = true; # Enable iio-sensor for automatic screen rotation and similar features.
    hardware.flipperzero.enable = true; # Enable support for the flipperzero device.
  };
}
