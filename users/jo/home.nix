{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./desktop/gnome.nix
    outputs.homeManagerModules.themes.catppuccin.global
    outputs.homeManagerModules.development.ssh
  ];

  nixpkgs = {
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

  # General packages
  home.packages = with pkgs; [
    qflipper
    wineWowPackages.waylandFull
    vesktop
    lunar-client
    steam

    # For development
    avra
    avrdude
    vscodium
    jetbrains.phpstorm
    git
    nodejs_22

    # Work stuff for when I'm not actually working
    teams-for-linux
    enpass
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Enable and configure git
  programs.git = {
    enable = true;

    userEmail = "jo@thevoid.cafe";
    userName = "Jo";

    extraConfig = {
      user = {
        signingkey = "$HOME/.ssh/id_ed25519";
      };

      init = {
        defaultBranch = "main";
      };

      color = {
        ui = true;
      };
    };
  };

  programs.gh = {
    enable = true;

    gitCredentialHelper = {
      enable = true;

      hosts = [
        "https://github.com"
        "https://gist.github.com"
        "https://git.thevoid.cafe"
        "https://gitlab.org"
        "https://git.semiko.dev"
        "https://bitbucket.org"
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
