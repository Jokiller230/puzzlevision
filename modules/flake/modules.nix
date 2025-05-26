{ self, ... }:
{
  flake = {
    # TODO: figure out why this isn't working correctly
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
