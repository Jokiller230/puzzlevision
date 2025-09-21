{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    if builtins.pathExists ./Packet_Tracer822_amd64_signed.deb then
      [
        (ciscoPacketTracer8.override { packetTracerSource = ./Packet_Tracer822_amd64_signed.deb; })
      ]
    else
      [ ];
}
