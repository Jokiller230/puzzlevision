{
  pkgs,
  config,
  ...
}: let 
  sshDir = "${config.home.homeDirectory}/.ssh";
in {
  home.packages = with pkgs; [
    openssh
  ];

  services.ssh-agent.enable = true;

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
