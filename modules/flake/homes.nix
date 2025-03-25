{
  lib,
  inputs,
  puzzlelib,
  ...
}: let
  HomeConfiguration = args: let
    nixpkgs = inputs.nixpkgs;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = (puzzlelib.dirToModuleList ../home) ++ args.modules;
      extraSpecialArgs =
        {
          inherit (args) nixpkgs;
        }
        // args.extraSpecialArgs;
    };
in {
  perSystem = {
    # TODO Dynamically export homeConfigurations by consuming contents of /homes/user-name
  };
}
