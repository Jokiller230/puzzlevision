{
  description = "Jo's NixOS configuration";

  inputs = {
    # Nixpkgs instance.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Snowfall lib imposes an opinionated file-structure, which makes things a little easier sometimes.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret management tool
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager for managing the /home directory.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware specific tweaks and performance optimizations.
    hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Catppuccin theme nix configuration.
    catppuccin = {
      url = "github:catppuccin/nix";
    };

    # Declarative management of Flatpak packages.
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs; # Providing flake inputs to Snowfall Lib.
      src = ./.; # "src" must point to the root of the flake.

      snowfall = {
        # Namespace for this flake's packages, library and overlays.
        namespace = "puzzlevision";

        meta = {
          name = "jos-nixos-configuration"; # Used in certain places, like documentations. No spaces.
          title = "Jo's NixOS configuration"; # Basically just for decorational purposes.
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      # Apply some NixOS modules globally.
      systems.modules.nixos = with inputs; [
        sops-nix.nixosModules.sops
      ];

      # Apply some home-manager modules globally.
      homes.modules = with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
        catppuccin.homeManagerModules.catppuccin
      ];
    };
}
