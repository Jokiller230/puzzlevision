<br>
<div align="center"><img src=".github/assets/puzzlevision.png" width="120px" height="auto"></div>

<h1 align="center">✨ Puzzlevision ✨<br></h1>
<div align="center">Non-stop entertainment! The wackiest NixOS configuration to-date.</div>
<br>
<div align="center">
    <img src=".github/assets/powered-by-nixos.gif" width="88px" height="31px">
    <img src=".github/assets/i-love-reproducing-nix-btw.gif" width="88px" height="31px">
    <img src=".github/assets/anything-but-windows.gif" width="88px" height="31px">
    <img src=".github/assets/code-with-zed.webp" width="88px" height="31px">
</div>
<br>

## 🚧 State of development
All the basic functionality of v2 should be working correctly, including:

- The custom lib implementation at self.lib, recursively built from the contents of the `lib` directory.
- Loading of systems from the `systems` directory, using easy-hosts.
  - A basic workstation archetype for desktop systems.
- Creating users in your systems through ${self.namespace}.users,
automatically maps home-manager configurations from the `homes` directory to their corresponding users.

Since I am actively using this configuration on my main workstation, things are evolving quickly,
leftover issues are actively being resolved and the list of modules is ever-growing.
Nonetheless, one should still consider this implementation experimental.

My next goal is to setup an attic binary cache,
with a build/release workflow that runs in regular intervals.
(similar to isabelroses's workflow setup)

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

## 🔑 Secrets Management
Secrets are managed by the [sops-nix](https://github.com/Mic92/sops-nix) nixos/home-manager modules respectively.

- General secrets are stored within the `secrets` directory.
- System specific secrets are stored within their respective `systems/<system_type>/<system_name>/secrets` directory.

The following command may be used to convert the SSH host key of a new machine to an age key:

```sh
nix-shell -p ssh-to-age --run 'ssh-keyscan example.com | ssh-to-age'
```

Additionally, the following command may be used to create a new sops secret file:

```sh
nix-shell -p sops --run "sops secrets/example.yaml"
```

You may also encrypt arbitrary binary formats, like .cfg, using the following command:

> [!IMPORTANT]
> The original file location also HAS to match one of the sops creation rules, not just the output.
> Yes, I know this is stupid, and yes, I've wasted way too much time dealing with this :3

```sh
nix-shell -p sops --run "sops -e original_file.cfg > secrets/encrypted_file.cfg"
```

Lastly, when adding new systems, make sure to update any required secret files with the following command:

```sh
nix-shell -p sops --run "sops updatekeys secrets/example.yaml"
```

## 👷 CI/CD coverage
Currently, this repository houses 2 workflows, which are executed when pushing to the v2 branch.

#### ↪️ `Nix: check for unused code`
This workflow can be found in `.github/workflows/deadnix.yml`,
and should be pretty self-explanatory.

Here's what it does:
1. Checks out current branch
2. Finds any unused variables/imports etc...
3. Creates a new commit, instantly removing any unused code

#### ↪️ `Nix: validate flake`
This workflow can be found in `.github/workflows/validate.yml`.
It simply validates a flake using `nix flake check`.

To be specific, it does the following:
1. Checks out current branch
2. Installs nix with some experimental features (flakes, nix-command, recursive-nix, pipe-operator)
3. Runs `nix flake check` on the codebase

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
