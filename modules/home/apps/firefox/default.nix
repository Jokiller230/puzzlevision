{
  lib,
  self,
  config,
  ...
}:
let
  inherit (self) namespace;
  inherit (self.lib) mkOpt;
  inherit (lib) mkEnableOption types mkIf;

  cfg = config.${namespace}.apps.firefox;
in
{
  options.${namespace}.apps.firefox = {
    enable = mkEnableOption "the Firefox browser.";
    extensions = mkOpt (types.listOf types.str) [
      "uBlock0@raymondhill.net"
    ] "List of extension slugs to install";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        ExtensionSettings = builtins.foldl' (
          acc: id:
          acc
          // {
            ${id} = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
              installation_mode = "force_installed";
            };
          }
        ) { } cfg.extensions;
      };
    };
  };
}
