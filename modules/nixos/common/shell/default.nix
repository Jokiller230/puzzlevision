{
  lib,
  namespace,
  config,
  pkgs,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.shell;
in {
  options.${namespace}.common.shell = {
    enable = mkEnableOption "Modify the standard shell options";
  };

  config = mkIf cfg.enable {
    environment.shells = with pkgs; [ fish ];
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
  };
}
