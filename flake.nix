{
  description = "Jo's NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma manager
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Haumea (map directory structure into an attribute set)
    haumea = {
          url = "github:nix-community/haumea/v0.2.2";
          inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, haumea, ... } @inputs:
  let
    inherit (self) outputs;

    # Supported systems for this flake
    systems = [
      "x86_64-linux"
    ];

    # Function that generates an attribute by calling a function you pass to it
    # It takes each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # My custom packages
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # External resources (wallpapers, icons, dotfiles)
    resources = import ./resources;

    # My reusable modules for nixos
    nixosModules = haumea.lib.load {
      src = ./modules/nixos;
      inputs = { inherit inputs outputs; pkgs = nixpkgs.legacyPackages.x86_64-linux; };
    };

    # My reusable modules for home-manager
    homeManagerModules = haumea.lib.load {
      src = ./modules/home-manager;
      inputs = { inherit inputs outputs; pkgs = nixpkgs.legacyPackages.x86_64-linux; };
    };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      puzzlevision = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/puzzlevision/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "jo@puzzlevision" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./users/jo_puzzlevision/home.nix
        ];
      };
    };
  };
}
