{
  lib,
  ...
}: {
  home.file.".config/fish/themes/Catppuccin\ Frappe.theme".source = lib.snowfall.fs.get-file "resources/apps/fish/Catppuccin\ Frappe.theme";
}
