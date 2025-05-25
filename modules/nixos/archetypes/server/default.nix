{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.archetypes.server;
in {
  options.${namespace}.archetypes.server = {
    enable = mkEnableOption "the server archetype for your current system";
  };

  config = mkIf cfg.enable {
    puzzlevision = {
      system = {
        nix = {
          enable = true;
          use-lix = true;
        };
        grub.enable = true;
        networking.enable = true;
        kernel.enable = true;
        shell.enable = true;
        locale.enable = true;
      };

      services = {
        docker.enable = true;
      };
    };

    # Enable SSH for remote login
    services.openssh.enable = true;

    # SSH rate-limiting and bans
    services.fail2ban.enable = true;
  };
}
