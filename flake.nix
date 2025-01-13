{
  description = "Jo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake parts, a library that provides utilites for creating flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Provides an easy interface for loading systems from a directory
    easy-hosts.url = "github:isabelroses/easy-hosts";

    #
    home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./systems
      ];

      systems = [ "x86_64-linux" ];
    };
}
