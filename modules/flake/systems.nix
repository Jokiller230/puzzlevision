{
  lib,
  inputs,
  namespace,
  puzzlelib,
  ...
}:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easyHosts = {
    autoConstruct = true;
    path = ../../systems;

    shared = {
      specialArgs = {
        inherit namespace puzzlelib;
      };
    };

    perClass = class: {
      modules = [
        (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.default
        ])
      ] ++ (puzzlelib.dirToModuleList ../${class}); # Import modules based on current classname.
    };
  };
}
