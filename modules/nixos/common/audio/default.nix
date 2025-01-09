{
  lib,
  namespace,
  config,
  ...
}: with lib; with lib.${namespace};
let
  cfg = config.${namespace}.common.audio;
in {
  options.${namespace}.common.audio = { enable = mkEnableOption "whether to enable common audio support and tweaks"; };

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
