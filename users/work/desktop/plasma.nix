{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    outputs.homeManagerModules.themes.gruvbox.plasma
  ];

  home.packages = with pkgs; [
    kdePackages.sierra-breeze-enhanced
    kde-rounded-corners
  ];

  # Plasma configuration
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
    };
  };
}