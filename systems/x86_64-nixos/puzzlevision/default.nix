{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  users.users.jo.isNormalUser = true;
  users.users.jo.initialPassword = "balls";
  users.users.jo.createHome = true;

  # System configuration
  puzzlevision = {
    # TODO: improve home-manager configuration loading as development continues and make sure everything works correctly.
    users = {
      jo = {
        enable = true;
        initialPassword = "balls";
      };
    };

    desktop.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    firefox
    vscodium
  ];

  system.stateVersion = "25.05";
}
