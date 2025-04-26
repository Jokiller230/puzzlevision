{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  puzzlevision = {
    users.cyn = {
      enable = true;
      password = "cynical"; # For testing only, replace with sops secret before production use
      extraGroups = ["wheel"];
    };

    desktop.gnome.enable = true;
    system.grub.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    firefox
  ];

  system.stateVersion = "25.05";
}
