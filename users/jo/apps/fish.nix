{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  home.file.".config/fish/themes/Catppuccin\ Frappe.theme".source = "${outputs.resources.app-files}/fish/Catppuccin\ Frappe.theme";
}
