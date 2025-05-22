{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.system.nix;
in {
  options.${namespace}.system.nix = {
    enable = mkEnableOption "Nix configuration overrides.";
    use-lix = mkEnableOption "Lix as an alternative to CppNix.";
    use-nixld = mkEnableOption "the use of dynamically linked executables on nix based systems.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = ["nix-command" "flakes"];
        keep-derivations = true;
        keep-outputs = true;
        max-jobs = "auto";
        warn-dirty = false;
      };

      # Garbage collection configuration.
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };

      package = mkIf cfg.use-lix pkgs.lix; # Enable LIX
    };

    nixpkgs.config.allowUnfree = true;

    # Dynamic libraries for unpackaged programs
    programs.nix-ld = mkIf cfg.use-nixld {
      enable = true;
      libraries = with pkgs; [
        glibc
        libcxx
      ];
    };
  };
}
