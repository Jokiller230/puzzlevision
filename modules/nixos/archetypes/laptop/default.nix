{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.archetypes.laptop;
in {
  options.${namespace}.archetypes.laptop = {
    enable = mkEnableOption "the laptop archetype.";
  };

  config = mkIf cfg.enable {
    ${namespace} = {
      # Inherit from workstation archetype
      archetypes.workstation.enable = true;
    };

    hardware.sensor.iio.enable = true; # Enable iio-sensor for automatic screen rotation and similar features.
  };
}
