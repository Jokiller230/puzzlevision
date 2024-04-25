# nix-config

Jo's absolutely insane NixOS configuration - not in the good way

## Deployment

Run this to apply your system configuration.
```sh
sudo nixos-rebuild switch --flake .#hostname
```

Run this, to apply your home-manager configuration.
```sh
home-manager switch --flake .#username@hostname
```
