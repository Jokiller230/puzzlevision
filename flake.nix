{
  description = "Jo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    easy-hosts.url = "github:isabelroses/easy-hosts";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;

      imports = [
        ./modules/flake
      ];

      systems = [ "x86_64-linux" ];
      flake = {
        # Exposing the flake namespace
        namespace = "puzzlevision";
      };
    };
}
