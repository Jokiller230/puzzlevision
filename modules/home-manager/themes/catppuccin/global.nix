{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "frappe";

    pointerCursor.enable = true;
    pointerCursor.accent = "blue";
    pointerCursor.flavor = "frappe";
  };
}
