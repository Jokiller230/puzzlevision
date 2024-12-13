{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.security.yubikey;
in 
{
  options.${namespace}.security.yubikey = with types; {
    enable = mkEnableOption "Enable the Yubikey as a security device.";
    key-id = mkOption {
      type = listOf str;
      default = [ "30650551" ];
      example = [ "123456" "1234567" ];
      description = "Register additional Yubikey IDs.";
    };
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
  };
}