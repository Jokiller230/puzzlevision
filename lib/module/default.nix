{lib, ...}: {
  # Create a NixOS module option on a single line.
  mkOpt = type: default: description:
    lib.mkOption {inherit type default description;};

  mkBool = default: description:
    lib.mkOption {
      inherit default description;
      type = lib.types.bool;
    };

  # Todo: add mkIfElse function
}
