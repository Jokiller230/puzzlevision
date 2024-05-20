{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    tela-icon-theme
    outputs.packages.x86_64-linux.themes.kde-gruvbox-colors
  ];

  programs.plasma.workspace = {
    iconTheme = "Tela-green-dark";
    colorScheme = "GruvboxColors";
    wallpaper = "${outputs.resources.wallpapers}/gruvbox/green_pokemon_guy.png";
  };
}