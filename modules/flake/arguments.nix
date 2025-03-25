{config, ...}: {
  # Apply some useful module arguments.
  _module.args = {
    namespace = config.flake.namespace;
  };
}
