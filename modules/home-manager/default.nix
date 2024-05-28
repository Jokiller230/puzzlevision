{
  themes = {
    gruvbox = {
      plasma = import ./themes/gruvbox/plasma.nix;
    };

    catppuccin = {
      gnome = import ./themes/catppuccin/gnome.nix;
      global = import ./themes/catppuccin/global.nix;
    };
  };

  development = {
    ssh = import ./development/ssh.nix;
  };
}