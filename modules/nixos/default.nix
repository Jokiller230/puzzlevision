# Collection of reusable nixos modules (https://nixos.wiki/wiki/Module)
# These shouldn't include personal configurations, but much rather stuff that can be shared across multiple configurations
{
  # List your module files here
  # my-module = import ./my-module.nix;
  desktop = import ./desktop;
}
