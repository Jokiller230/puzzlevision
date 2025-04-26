{
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.system.grub;
in {
  options.${namespace}.system.grub = {
    enable = mkEnableOption "the grub bootloader.";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = false;

    boot.loader.grub = {
      enable = true;
      devices = ["nodev"];
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
