{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  # Enable arRPC for discord Rich Presence stuffs
  services.arrpc.enable = true;

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    discord.enable = false;

    config = {
      useQuickCss = true;
      themeLinks = [
        (mkIf config.catppuccin.enable "https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css")
      ];

      frameless = true;
      plugins = {
        betterFolders = {
          enable = true;
          closeAllFolders = true;
          closeAllHomeButton = true;
          closeOthers = true;
        };

        fakeNitro = {
          enable = true;
          enableStickerBypass = false;
          enableEmojiBypass = false;
        };

        betterSettings.enable = true;
        betterUploadButton.enable = true;
        blurNSFW.enable = true;
        clearURLs.enable = true;
        callTimer.enable = true;
        consoleJanitor.enable = true;
        copyEmojiMarkdown.enable = true;
        userMessagesPronouns.enable = true;
        reviewDB.enable = true;

        # Vesktop exclusive
        webRichPresence.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
