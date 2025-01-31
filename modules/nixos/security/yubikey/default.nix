{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.security.yubikey;
in
{
  options.${namespace}.security.yubikey = with lib.types; {
    enable = mkEnableOption "Enable the Yubikey as a security device.";
    key-id = mkOption {
      type = listOf str;
      default = [ "30650551" ];
      example = [ "123456" "1234567" ];
      description = "Register additional Yubikey IDs.";
    };
    enable-agent = mkEnableOption "Enable the Yubikey agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yubikey-manager yubioath-flutter ];

    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    services.yubikey-agent.enable = cfg.enable-agent;

    programs.ssh.extraConfig = mkIf cfg.enable-agent ''
        Host *
            IdentityAgent /usr/local/var/run/yubikey-agent.sock
    '';

    environment.sessionVariables = mkIf cfg.enable-agent {
        SSH_AUTH_SOCK = "/usr/local/var/run/yubikey-agent.sock";
    };
  };
}
