{
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  puzzlevision = {
    # TODO: improve home-manager configuration loading as development continues and make sure everything works correctly.
    users = {
      jo = {
        enable = true;
        initialPassword = "balls";
        extraGroups = [ "wheel" ];
      };
    };

    desktop.gnome.enable = true;
    utils.vm.enable = true;
    common.grub.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    firefox
  ];

  system.stateVersion = "25.05";
}
