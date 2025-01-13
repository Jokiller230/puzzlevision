{
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easyHosts = {
    autoConstruct = true;
    path = ../systems;

    shared.modules = [
      ../homes
    ];

    perClass =
      class:
      {
        modules = [
          "${self}/modules/${class}"

          (lib.optionals (class == "nixos") [
            inputs.home-manager.nixosModules.home-manager
          ])
        ];
      };
  };
}
