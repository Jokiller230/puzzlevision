{
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;
in
{
  options.${namespace}.user = with lib.types; {
    name = mkOpt str "Jo" "The user's short name.";
    fullName = mkOpt str "Johannes Reckers" "The user's full name.";
    email = mkOpt str "reckers.johannes@proton.me" "The user's primary E-Mail address.";
    icon = mkOpt str "./icon.jpg" "The path to the users prefered icon.";
  };
}
