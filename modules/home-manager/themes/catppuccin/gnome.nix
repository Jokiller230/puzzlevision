{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    catppuccin.enable = true;
  };
}