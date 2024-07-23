{
  description = "Jo's NixOS configuration";

  inputs = {
    # Nixpkgs instance.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Snowfall lib imposes an opinionated file-structure, which makes things a little easier sometimes.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager for managing the /home directory.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware specific tweaks and performance optimizations.
    hardware.url = "github:NixOS/nixos-hardware/master";

    # Catppuccin theme nix configuration.
    catppuccin.url = "github:catppuccin/nix";

    # Declarative management of Flatpak packages.
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs; # Providing flake inputs to Snowfall Lib.
      src = ./.; # "src" must point to the root of the flake.

      snowfall = {
        # "root" can be used, to tell Snowfall Lib where to look for Nix files.
        # root = ./nix;

        # Namespace for this flake's packages, library and overlays.
        namespace = "puzzlevision";

        meta = {
          name = "jos-nixos-configuration"; # Used in certain places, like documentations. No spaces.
          title = "Jo's NixOS configuration"; # Basically just for decorational purposes.
        };
      };

      channels-config = {
        allowUnfree = true; # Allow unfree packages.
      };

      # Apply some home-manager modules globally.
      homes.modules = with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
      ];

      homes.users."jo@puzzlevision".modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
      ];
    };
}
