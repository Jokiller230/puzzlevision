{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  virtualisation.vmVariant = {
    virtualisation = {
      cores = 6;
      memorySize = 2048;
    };
  };

  # Todo: pass a set of users to enable from within easy-hosts and automatically map the corresponding home-manager configurations
  # ${namespace} = {
  #   mainUser = "jo";
  #   users = [ "jo" ];
  # };
  users.users.jo.isNormalUser = true;
  users.users.jo.initialPassword = "balls";
  users.users.jo.createHome = true;

  # Enable Plasma6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    ghostty
  ];

  system.stateVersion = "25.05";
}
