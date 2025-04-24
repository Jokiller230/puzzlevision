{ self, ... }:
{
  flake = {
    nixosModules.puzzlevision = self.lib.mkModule {
      class = "nixos";
      modules = self.lib.dirToModuleList ../nixos;
    };

    homeModules.puzzlevision = self.lib.mkModule {
      class = "home";
      modules = self.lib.dirToModuleList ../home;
    };
  };
}
