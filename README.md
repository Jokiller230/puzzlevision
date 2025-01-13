<br>
<div align="center"><img src="assets/puzzlevision.png" width="120px" height="auto"></div>

<h1 align="center">✨ Puzzlevision ✨<br></h1>
<div align="center">Non-stop entertainment! The wackiest NixOS configuration to-date.</div>
<br>

## 🚧 State of development
Version 2.0 is still very much an experiment and not ready to be used in a production
environment. If you must, try running it within a VM using the provided deployment
instructions.

## 🚀 Deployment
To deploy a system run the following command in your terminal of choice.

```sh
sudo nixos-rebuild switch --flake .#hostname
```

If you're interested in a quick way to experiment with this configuration,
you may use the following command to build a VM.

```sh
sudo nixos-rebuild build-vm --flake .#hostname
```

## 📝 Goals and improvements
The main goals of this rewritten flake are:

- using flake-parts in place of Snowfall lib
- significantly improving the re-usability of all modules
- avoiding anti-patterns, such as `with lib; with lib.${namespace};`
- improved secrets management
- keeping external assets closer to their related nix file, e.g. wallpapers in
the desktop modules folder

## 🏗️ Structure
The structure this flake aims to build on is relatively simple to grasp.

```
flake.nix  --> The flake.
/systems   --> NixOS configurations for various types of systems, using easy-hosts.
/modules   --> Modules that are mapped to their corresponding easy-hosts class (and home modules).
  /nixos   --> (example) Modules specific to the nixos class configured in easy-hosts.
/homes     --> Directory for home-manager configurations, not specific to the system type.
/lib       --> A place for custom lib attributes exposed on the flake namespace (lib.puzzlevision.mkOpt).
(more...)  --> Additional directories have been considered (e.g. shells), but as of right now, they serve no use to me.
```

## 🎨 Credits
Parts of this flake were inspired by the likes of:

- [isabelroses](https://github.com/isabelroses)
- [uncenter](https://github.com/uncenter)

Many thanks to their hard work!
