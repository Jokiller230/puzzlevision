{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.common.nix;
in {
  options.${namespace}.common.nix = {
    enable = mkEnableOption "Overwrite the default Nix configuration.";
    use-lix = mkEnableOption "Enable Lix as an alternative to CppNix.";
    use-nixld = mkEnableOption "Enable the use of dynamically linked executables on nix based systems.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [ "nix-command" "flakes" ];
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

      extraOptions = ''
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      '';

      package = mkIf cfg.use-lix pkgs.lix; # Enable LIX
    };

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
