{
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = self.lib.dirToPkgAttrSet ../../pkgs pkgs { };
    };
}
