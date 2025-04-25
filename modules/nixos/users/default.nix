{
  lib,
  config,
  self,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt dirToModuleList;

  cfg = config.${namespace}.users;

  # The identifier of the current system type, e.g. "x86_64-linux" or "aarch64-darwin"
  system = pkgs.system;

  # Type for a user configuration
  userType = types.submodule {
    options = {
      enable = mkEnableOption "this user";
      initialPassword = mkOpt (types.nullOr types.str) null "Initial password for the user";
      password = mkOpt (types.nullOr types.str) null "Plaintext password for the user";
      hashedPassword = mkOpt (types.nullOr types.str) null "Hashed password for the user";
      isNormalUser = mkOpt types.bool true "Whether this user is a normal user";
      extraGroups = mkOpt (types.listOf types.str) [] "Extra groups for the user";
    };
  };

  # Function to get home configuration path for a username
  getHomeConfigPath = username: "${self.outPath}/homes/${system}/${username}";

  # Function to check if a home configuration exists for a username
  homeConfigExists = username:
    let path = getHomeConfigPath username;
    in builtins.pathExists "${path}/default.nix";

  # Import all home-manager modules
  homeModules = dirToModuleList "${self.outPath}/modules/home";
in {
  options.${namespace}.users = mkOption {
    type = types.attrsOf userType;
    default = {};
    description = "User configurations with auto-imported home-manager setup";
  };

  config = {
    # Ensure users are fully managed by NixOS
    users.mutableUsers = false;

    # Create the actual system users
    users.users = lib.mapAttrs (username: userConfig:
      mkIf userConfig.enable {
        name = username;
        inherit (userConfig) extraGroups initialPassword hashedPassword isNormalUser password;
      }
    ) cfg;

    # Configure home-manager with auto-imported user configuration
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit self;
        namespace = self.namespace;
      };

      users = lib.mapAttrs (username: userConfig:
        mkIf (userConfig.enable && homeConfigExists username) (
          { ... }: {
            imports = [
              (getHomeConfigPath username) # Import the user's specific home configuration
            ]; #++ homeModules; # Include all generalized home modules

            home.stateVersion = lib.mkDefault config.system.stateVersion;
          }
        )
      ) cfg;
    };
  };
}
