# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  themes = {
    kde-gruvbox-colors = pkgs.callPackage ./themes/kde-gruvbox-colors.nix { };
  };

  gnomeExtensions = {
    rounded-window-corners = pkgs.callPackage ./gnomeExtensions/rounded-window-corners.nix { };
  };
}
