{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.utils.vm;
in {
  options.${namespace}.utils.vm = {
    enable = self.lib.mkBool true "Whether to enable custom vm presets";
    preset = self.lib.mkOpt lib.types.str "performance" "Specify the prefered vm settings preset: performance, balance or powersave";
  };

  config = mkIf cfg.enable {
    virtualisation.vmVariant = {
      virtualisation = {
        cores = 6;
        memorySize = 4096;
        graphics = true;
      };
    };
  };
}
