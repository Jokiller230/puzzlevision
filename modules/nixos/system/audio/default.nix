{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (self) namespace;

  cfg = config.${namespace}.system.audio;
in
{
  options.${namespace}.system.audio = {
    enable = mkEnableOption "system audio support.";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
