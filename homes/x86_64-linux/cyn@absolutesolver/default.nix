{
  pkgs,
  ...
}:
{
  # Declare user packages.
  home.packages = with pkgs; [
    ### Runtimes
    nodejs_22
    bun

    ### Tools
    git
  ];

  home.stateVersion = "24.05";
}
