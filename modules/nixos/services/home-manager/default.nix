{ ... }:
{
  # Todo: rewrite as recursive operation, based on ${namespace}.users
  system.userActivationScripts = {
    removeConflictingHomeManagerBackups = {
      text = ''
        rm -f /home/jo/.gtkrc-2.0.homeManagerBackupFileExtension
        rm -f /home/jo/.config/gtk-3.0/gtk.css.homeManagerBackupFileExtension
        rm -f /home/jo/.config/gtk-4.0/gtk.css.homeManagerBackupFileExtension
      '';
    };
  };

  home-manager.backupFileExtension = "homeManagerBackupFileExtension";
}
