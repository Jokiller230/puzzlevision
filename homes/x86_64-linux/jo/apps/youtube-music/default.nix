{
  lib,
  config,
  osConfig,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  programs.youtube-music = {
    enable = true;
    options = {
      tray = true;
      trayClickPlayPause = true;
      resumeOnStart = false;

      themes = [
        (mkIf config.catppuccin.enable ./catppuccin-${config.catppuccin.flavor}.css)
      ];

      language = osConfig.${namespace}.system.locale.keymap;
      autoUpdates = false;
    };

    plugins = {
      discord.enabled = true;
    };
  };
}
