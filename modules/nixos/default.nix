{
  desktop = {
    kde = import ./desktop/kde.nix;
    gnome = import ./desktop/gnome.nix;
    cosmic = import ./desktop/cosmic.nix;
  };
}