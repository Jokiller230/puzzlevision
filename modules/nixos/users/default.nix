{
  lib,
  self,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) types mkEnableOption mkOption mkIf;
  inherit (self) namespace;
  inherit (self.lib) dirToModuleList;

  # The identifier of the current system type, e.g. "x86_64-linux" or "aarch64-darwin"
  system = pkgs.system;
  cfg = config.${namespace}.users;

  userSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "this user.";
      isNormalUser = self.lib.mkBool true "Whether this user is considered a normal user.";
      isSystemUser = self.lib.mkBool false "Whether this user is considered a system user.";
      initialPassword = self.lib.mkOpt (types.nullOr types.str) null "Plaintext insecure initial user password, only recommended for testing.";
      password = self.lib.mkOpt (types.nullOr types.str) null "Plaintext insecure user password, only recommended for testing.";
      extraGroups = self.lib.mkOpt (types.listOf types.str) [] "List of additional groups this user belongs to.";
    };
  };

  getHomeConfigPath = username: "${self.outPath}/homes/${system}/${username}";
  homeConfigExists = username: let
    path = getHomeConfigPath username;
  in
    builtins.pathExists "${path}/default.nix";

  homeModules = dirToModuleList "${self.outPath}/modules/home";
in {
  options.${namespace}.users = mkOption {
    type = types.attrsOf userSubmodule;
    default = {};
    description = "List of users to create. Also handles home configurations, placed in self.outPath/homes/[x86_64-linux, aarch64-linux, etc...], through home-manager.";
  };

  config = {
    # TODO: fix this
    #nix.settings.trusted-users = ["root" (lib.forEach cfg (username: toString username))];

    # Manage users declaratively and map userConfig to users.users by name;
    users.mutableUsers = false;
    users.users = lib.mapAttrs (username: userConfig:
      mkIf userConfig.enable {
        name = username;
        inherit (userConfig) isNormalUser isSystemUser initialPassword password extraGroups;
      })
    cfg;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit self system;
        namespace = self.namespace;
      };

      users =
        lib.mapAttrs (
          username: userConfig:
            mkIf (userConfig.enable && homeConfigExists username) (
              {osConfig, ...}: {
                # Import user home configuration and general home modules
                imports = [(getHomeConfigPath username) inputs.sops-nix.homeManagerModules.sops inputs.catppuccin.homeModules.default] ++ homeModules;

                home.stateVersion = lib.mkDefault osConfig.system.stateVersion;
              }
            )
        )
        cfg;
    };
  };
}
