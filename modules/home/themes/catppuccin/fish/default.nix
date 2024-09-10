{
  lib,
  ...
}: {
  home.file.".config/fish/themes/Catppuccin\ Macchiato.theme".source = lib.snowfall.fs.get-file "resources/apps/fish/Catppuccin\ Macchiato.theme";
}
