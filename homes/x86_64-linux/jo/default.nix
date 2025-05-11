{pkgs, ...}: {
  puzzlevision = {
    themes.catppuccin.enable = true;
  };

  home.packages = with pkgs; [
    zed-editor
    firefox
  ];

  home.stateVersion = "25.05";
}
