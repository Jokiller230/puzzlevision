{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  config,
  ...
}: let
  sshDir = "${config.home.homeDirectory}/.ssh";
in {
  home.packages = with pkgs; [
    openssh
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  matchBlocks = {
    "github.com" = {
      identityFile = "${sshDir}/id_ed25519";
      identitiesOnly = true;
      user = "git";
    };

    "gitlab.com" = {
      identityFile = "${sshDir}/id_ed25519";
      identitiesOnly = true;
      user = "git";
    };

    "bitbucket.org" = {
      identityFile = "${sshDir}/id_ed25519";
      identitiesOnly = true;
      user = "git";
    };
  };
}