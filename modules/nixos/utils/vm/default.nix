{
  lib,
  config,
  namespace,
  puzzlelib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (puzzlelib) mkOpt mkBool;

  cfg = config.${namespace}.utils.vm;
in {
  options.${namespace}.utils.vm = {
    enable = mkBool true "Whether to enable custom vm presets";
    preset = mkOpt lib.types.str "performance" "Specify the prefered vm settings preset: performance, balance or powersave";
  };

  config = mkIf cfg.enable {
    virtualisation.vmVariant = mkMerge [
      (mkIf cfg.preset
        == "performance" {
          virtualisation = {
            cores = 6;
            memorySize = 4096;
            graphics = true;
          };
        })
      (mkIf cfg.preset
        == "balance" {
          virtualisation = {
            cores = 4;
            memorySize = 2048;
          };
        })
      (mkIf cfg.preset
        == "powersave" {
          virtualisation = {
            cores = 2;
            memorySize = 1024;
          };
        })
    ];
  };
}
