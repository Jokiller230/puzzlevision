{
  lib,
  puzzlelib,
  ...
}:
let
  # Utility function to read a directory and return its contents.
  readDirectory = directory: builtins.readDir directory;

  # Utility function to handle each filesystem entity (file or directory).
  filesystemEntityToAttrSet = directory: importArgs: name: type:
    if type == "directory" then
      dirToAttrSet "${directory}/${name}" importArgs
    else if name == "default.nix" then
      import "${directory}/${name}" importArgs
    else
      {};

  filesystemEntityToList = directory: name: type:
    if type == "directory" then
      dirToModuleList "${directory}/${name}"
    else if name == "default.nix" then
      [ "${directory}/${name}" ]
    else
      [];

  dirToModuleList = directory:
    let
      readDir = readDirectory directory;
    in
      builtins.foldl' (acc: name:
        acc ++ (filesystemEntityToList directory name (builtins.getAttr name readDir))
      ) [] (builtins.attrNames readDir);

  # Utility function to recursively load modules from a directory.
  dirToAttrSet = directory: importArgs:
    let
      # Read provided directory only once at the very start and save the result.
      readDir = readDirectory directory;
    in
      # Iterate over the attr names of a readDir operation.
      builtins.foldl' (acc: name:
        # Merge outputs of handling a filesystem entity (file or directory) into accumulator.
        # Files return attribute sets with their resulting expressions, directories return the result of multiple file handling operations.
        acc // (filesystemEntityToAttrSet directory importArgs name (builtins.getAttr name readDir))
      ) {} (builtins.attrNames readDir);
in
{
  # Add lib.${namespace} attribute to module arguments, for easy access.
  # Additionally, pass on dirToAttrSet method on lib.${namespace} for reusability in other modules.
  _module.args = {
    puzzlelib = dirToAttrSet ../../lib { inherit lib puzzlelib; } // { inherit dirToAttrSet dirToModuleList filesystemEntityToList filesystemEntityToAttrSet; };
  };
}
