{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    vscodium
    cmatrix
  ];

  home.stateVersion = "25.05";
}
