<br>
<div align="center"><img src="assets/puzzlevision.png" width="120px" height="auto"></div>

<h1 align="center">✨ Puzzlevision ✨<br></h1>
<div align="center">Non-stop entertainment! The wackiest NixOS configuration to-date.</div>
<br>

## 🚧 State of development
All the basic functionality of v2 should be working correctly, including:

- The custom lib implementation at self.lib, recursively built from the contents of the `lib` directory.
- Loading of systems from the `systems` directory, using easy-hosts.
  - A basic workstation archetype for desktop systems.
- Creating users in your systems through ${self.namespace}.users,
automatically maps home-manager configurations from the `homes` directory to their corresponding users.

Nonetheless, one should still consider this implementation experimental,
once I start using this on my laptop,
I'll aim for production grade stability.

## 🚀 Deployment
To deploy a system run the following command in your terminal of choice.

```sh
sudo nixos-rebuild switch --flake .#hostname --accept-flake-config
```

If you're interested in a quick way to experiment with this configuration,
you may use the following command to build a VM.

```sh
sudo nixos-rebuild build-vm --flake .#hostname --accept-flake-config
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
- [xaiyadev](https://github.com/xaiyadev)

and documentations such as:

- [flake-parts](https://flake.parts)
- [NixOS and Flakes book](https://nixos-and-flakes.thiscute.world)

many thanks to their hard work!
