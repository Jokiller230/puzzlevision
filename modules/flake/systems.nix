{
  inputs,
  namespace,
  ...
}:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easyHosts = {
    autoConstruct = true;
    path = ../../systems;

    shared = {
      specialArgs = {
        inherit namespace;
      };
    };

    perClass = class: {
      modules = [
        # Import modules based on current classname.
        ../${class}

        (inputs.nixpkgs.lib.optionals (class == "nixos") [
          inputs.home-manager.nixosModules.default
        ])
      ];
    };
  };
}
