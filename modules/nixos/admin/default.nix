{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;
in
{
  options.${namespace}.admin = with lib.types; {
    name = mkOpt str "Jo" "The short name of the system admin.";
    full-name = mkOpt str "Johannes Reckers" "The full name of the system admin.";
    email = mkOpt str "system@thevoid.cafe" "The E-Mail of the system admin. (Used for system services by default)";
  };
}
