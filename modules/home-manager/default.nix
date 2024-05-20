{
  themes = {
    gruvbox = {
      plasma = import ./themes/gruvbox/plasma.nix;
    };
  };

  development = {
    ssh = import ./development/ssh.nix;
  };
}