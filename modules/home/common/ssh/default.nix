{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}: {
  home.packages = with pkgs; [
    openssh
  ];
}
