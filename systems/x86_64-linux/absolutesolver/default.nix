{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
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

  # Set system configuration
  puzzlevision = {
    archetypes.server.enable = true;

    services = {
      traefik.enable = true;
    };
  };

  # Configure users.
  snowfallorg.users.cyn.admin = true;
  users.users.cyn.isNormalUser = true;
  users.users.cyn.extraGroups = [ "dialout" "docker" ];

  # Configure home-manager
  home-manager = {
    backupFileExtension = "homeManagerBackup";
  };

  # Install required system packages
  environment.systemPackages = with pkgs; [
    ### General
    nano
    vim

    ## Runtimes
    nodejs_22
    bun
  ];

  system.stateVersion = "24.05";
}
