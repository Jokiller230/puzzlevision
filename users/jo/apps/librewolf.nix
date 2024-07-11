{
  inputs,
  pkgs,
  outputs,
  lib,
  ...
}: {
  home.file.".librewolf/librewolf.overrides.cfg".text = ''
    defaultPref("identity.fxaccounts.enabled", true);
  '';
}
