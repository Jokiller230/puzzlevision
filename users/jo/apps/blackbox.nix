{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  home.file.".local/share/blackbox/schemes/Catppuccin-Macchiato.json".source = "${outputs.resources.app-files}/blackbox/Catppuccin-Macchiato.json";
}
