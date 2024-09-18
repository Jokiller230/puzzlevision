{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  imports = [
    ./hardware-configuration.nix
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Set hostname
  # Todo: move to common/networking module
  networking.hostName = "absolutesolver";

  # Set timezone.
  time.timeZone = "Europe/Berlin";

  # Enable docker
  virtualisation.docker.enable = true;

  # Set system Type
  puzzlevision.archetypes.server.enable = true;

  # Configure users.
  snowfallorg.users.jo.admin = true;
  users.users.jo.isNormalUser = true;
  users.users.jo.extraGroups = [ "dialout" "docker" ];

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Provide users with some sane default packages.
  environment.systemPackages = with pkgs; [
    ### General
    nano
    vim
  ];

  system.stateVersion = "24.05";
}
