{
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [
    inputs.easy-hosts.flakeModule
  ];

  easyHosts = {
    autoConstruct = true;
    path = ../../systems;

    perClass = class: {
      modules =
        (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ])
        ++ (self.lib.dirToModuleList ../${class}); # Import modules based on current classname.
    };
  };
}
