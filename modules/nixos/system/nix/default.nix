{
  lib,
  pkgs,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;

  cfg = config.${namespace}.system.nix;
in
{
  options.${namespace}.system.nix = {
    enable = mkEnableOption "Nix configuration overrides.";
    use-lix = mkEnableOption "Lix as an alternative to CppNix.";
    use-nixld = mkEnableOption "the use of dynamically linked executables on nix based systems.";
    trusted-users = mkOpt (types.listOf types.str) [
      "@wheel"
    ] "List of trusted users for this NixOS system.";
  };

  config = mkIf cfg.enable {
    nix = {
      optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };

      settings = {
        builders-use-substitutes = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        keep-derivations = true;
        keep-outputs = true;

        cores = 2;
        max-jobs = 8;
        warn-dirty = false;

        trusted-users = cfg.trusted-users;
      };

      # Garbage collection configuration.
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 3d";
      };

      package = mkIf cfg.use-lix pkgs.lix; # Enable LIX
    };

    nixpkgs.config.allowUnfree = true;

    # Dynamic libraries for unpackaged programs
    # Use nix run github:mic92/nix-index-database libName.so to find the correct Nix packages
    programs.nix-ld = mkIf cfg.use-nixld {
      enable = true;
      libraries = with pkgs; [
        # Core
        glibc
        libcxx
        expat
        nspr
        nss

        # Rendering / graphics
        mesa
        libglvnd
        libdrm
        libgbm
        xorg.libxshmfence

        # X11 stack
        xorg.libX11
        xorg.libxcb
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXi
        xorg.libXtst

        # Input / keyboard
        libxkbcommon

        # Wayland (optional)
        wayland

        # GTK / accessibility stack
        glib
        dbus
        at-spi2-core
        at-spi2-atk
        gtk3
        gdk-pixbuf
        pango
        cairo

        # Printing
        cups

        # Fonts / text
        freetype
        fontconfig
        harfbuzz

        # Sound
        alsa-lib
        pulseaudio
      ];
    };
  };
}
