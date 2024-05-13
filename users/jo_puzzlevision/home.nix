{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./desktop/kde.nix
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
    spotify
    qflipper
    wineWowPackages.waylandFull
    vesktop
    avra
    avrdude
    jetbrains.phpstorm
    teams-for-linux
    enpass
    thunderbird
  ];

  # home.file.".config/gtk-4.0/gtk.css".source = "${orchis}/share/themes/Orchis-Green-Dark-Compact/gtk-4.0/gtk.css";

  # Enable home-manager
  programs.home-manager.enable = true;

  # Enable and configure git
  programs.git = {
    enable = true;

    userEmail = "reckers.johannes@proton.me";
    userName = "Jo";

    # Enable git-credential-helper
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
