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

  easy-hosts = {
    autoConstruct = true;
    path = ../../systems;

    perClass = class: {
      modules =
        (lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.minegrub-theme.nixosModules.default
        ])
        ++ (self.lib.dirToModuleList ../${class}); # Import modules based on current classname.
    };
  };
}
