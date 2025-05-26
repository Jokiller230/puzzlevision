{
  lib,
  self,
  ...
}:
let
  inherit (lib) types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt;
in
{
  options.${namespace}.services = {
    domain = mkOpt types.str "thevoid.cafe" "The main system domain, used for exposing services.";
    mail =
      mkOpt types.str "system@thevoid.cafe"
        "The main system administration E-Mail, used for logs and services.";
  };
}
