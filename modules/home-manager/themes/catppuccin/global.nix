{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "frappe";
  };
}