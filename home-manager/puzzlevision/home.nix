{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Username and home directory
  home = {
    username = "jo";
    homeDirectory = "/home/jo";
  };

  # Plasma configuration
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      iconTheme = "Tela-Blue-Dark";
    };
  };

  # home.file.".config/gtk-4.0/gtk.css".source = "${orchis}/share/themes/Orchis-Green-Dark-Compact/gtk-4.0/gtk.css";

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
