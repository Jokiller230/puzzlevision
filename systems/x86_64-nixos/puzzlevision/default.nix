{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  # Enable Plasma6
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Todo: pass a set of users to enable from within easy-hosts and automatically map the corresponding home-manager configurations
  # Register "jo" as a user
  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = [ "dialout" "docker" ];
  users.users.jo.initialPassword = "balls";
  users.users.jo.createHome = true;

  environment.systemPackages = with pkgs; [
    ghostty
  ];

  system.stateVersion = "25.05";
}
