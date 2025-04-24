{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (self) namespace;
  inherit (self.lib) mkOpt dirToModuleList;

  cfg = config.${namespace}.users;

  system = builtins.currentSystem;
  systemClass =
    if builtins.match ".*-linux" system != null then "nixos"
    else if builtins.match ".*-darwin" system != null then "darwin"
    else "nixos"; # Default fallback

  # Type for a user configuration
  userType = types.submodule {
    options = {
      enable = mkEnableOption "Enable this user";
      initialPassword = mkOpt (types.nullOr types.str) null "Initial password for the user";
      hashedPassword = mkOpt (types.nullOr types.str) null "Hashed password for the user";
      isNormalUser = mkOpt types.bool true "Whether this user is a normal user";
      extraGroups = mkOpt (types.listOf types.str) [] "Extra groups for the user";
    };
  };

  # Function to get home configuration path for a username
  getHomeConfigPath = username: "${self.outPath}/homes/${systemClass}/${username}";

  # Function to check if a home configuration exists for a username
  homeConfigExists = username:
    let path = getHomeConfigPath username;
    in builtins.pathExists "${path}/default.nix";

  # Import all home-manager modules
  homeModules = dirToModuleList "${self.outPath}/modules/home";
in {
  imports = [
    # Import home-manager NixOS module
    # This assumes home-manager is available as a flake input
    self.inputs.home-manager.nixosModules.home-manager
  ];

  options.${namespace}.users = mkOption {
    type = types.attrsOf userType;
    default = {};
    description = "User configurations with auto-imported home-manager setup";
  };

  config = {
    # Create the actual users
    users.users = lib.mapAttrs (username: userConfig:
      mkIf userConfig.enable {
        name = username;
        isNormalUser = userConfig.isNormalUser;
        inherit (userConfig) extraGroups;
        initialPassword = userConfig.initialPassword;
        hashedPassword = userConfig.hashedPassword;
      }
    ) cfg;

    # Configure home-manager with auto-imported configs
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
            ] ++ homeModules; # Include all home modules from /modules/home
          }
        )
      ) cfg;
    };
  };
}
