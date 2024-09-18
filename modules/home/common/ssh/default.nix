{
  lib,
  pkgs,
  inputs,
  namespace,
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
  };
}
