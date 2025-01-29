{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  users.users.jo.isNormalUser = true;
  users.users.jo.initialPassword = "balls";
  users.users.jo.createHome = true;

  # System configuration
  puzzlevision = {
    # Todo: pass a set of users to enable from within easy-hosts and automatically map the corresponding home-manager configurations
    # mainUser = "jo";
    # users = [ "jo" ];

    desktop.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
  ];

  system.stateVersion = "25.05";
}
