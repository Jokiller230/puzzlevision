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

    hardware.url = "github:NixOS/nixos-hardware/master";

    catppuccin.url = "github:catppuccin/nix";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  };

  outputs = { self, nixpkgs, home-manager, hardware, catppuccin, nix-flatpak, ... } @inputs:
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
    # My custom packagess
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # External resources (wallpapers, icons, dotfiles)
    resources = import ./resources;

    # My reusable modules for nixos
    nixosModules = import ./modules/nixos;

    # My reusable modules for home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      puzzlevision = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          home-manager.nixosModules.home-manager
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
          ./users/jo/home.nix
          nix-flatpak.homeManagerModules.nix-flatpak
          catppuccin.homeManagerModules.catppuccin
        ];
      };

      "work@puzzlevision" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./users/work/home.nix
        ];
      };

      "gaming@puzzlevision" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./users/gaming/home.nix
        ];
      };
    };
  };
}
