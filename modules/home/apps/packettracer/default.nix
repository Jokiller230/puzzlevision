{
  config,
  self,
  pkgs,
  lib,
  ...
}:
let
  inherit (self) namespace;
  inherit (self.lib) mkOpt;
  inherit (lib) mkEnableOption types mkIf;

  cfg = config.${namespace}.apps.packettracer;
in
{
  options.${namespace}.apps.packettracer = {
    enable = mkEnableOption "the Cisco Packettracer application, a network emulator.";
    binaryPath =
      mkOpt types.path null
        "The path of the Packettracer binary. Has to be downloaded from Cisco Netacad";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (ciscoPacketTracer8.override { packetTracerSource = cfg.binaryPath; })
    ];
  };
}
