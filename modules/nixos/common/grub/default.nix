{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.grub;
in {
  options.${namespace}.common.grub = { enable = mkEnableOption "grub"; };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = false;

    boot.loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiInstallAsRemovable = true;
      efiSupport = true;

      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
  };
}
