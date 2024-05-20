{
  pkgs,
  lib,
  outputs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./desktop/plasma.nix
    outputs.homeManagerModules.development.ssh
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "work";
    homeDirectory = "/home/work";
  };

  home.packages = with pkgs; [
		jetbrains.phpstorm
		thunderbird
		teams-for-linux
		enpass
		vscodium
  ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
