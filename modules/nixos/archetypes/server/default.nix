{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.archetypes.server;
in {
  options.${namespace}.archetypes.server = { enable = mkEnableOption "Enable the server archetype for your current system"; };

  config = mkIf cfg.enable {
    # Enable modules
    puzzlevision = {
      common = {
        nix = {
          enable = true;
          use-lix = true;
        };
        grub.enable = true;
        networking.enable = true;
        kernel.enable = true;
        shell.enable = true;
        hardware.enable = true;
        locale.enable = true;
      };
    };

    # Enable SSH for remote login
    services.openssh.enable = true;
  };
}
