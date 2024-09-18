{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.apps.development.zed-editor;

  zed-fhs = pkgs.buildFHSUserEnv {
    name = "zed";
    targetPkgs = pkgs:
    with pkgs; [
      zed-editor
    ];
    runScript = "zed";
  };
in {
  options.${namespace}.apps.zed-editor = { enable = mkEnableOption "zed-editor"; };

  config = mkIf cfg.enable {
    home.packages = [zed-fhs];
  };
}
