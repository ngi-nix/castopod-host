# Castopod Host

This repository is a Nix flake that packages Castopod Host
([source](https://code.podlibre.org/podlibre/castopod-host), [website](https://castopod.org/)),
a free and open source podcast hosting solution. The flake interface provides
several potential points of contact, including:
- the server alone as a package
- an overlay adding that package to a package set (IE nixpkgs)
- a NixOS module that runs the server and some other services it requires
- a NixOS container configuration that serves as an example of using the module


### updating

The Castopod Host source is a flake input, and can be updated via
`nix flake lock --update-input castopod-host-src`. Unfortunately, however, it is
also necessary to maintain Nix expressions in this repo that represent dependencies
specified in the source repo's `package.json`, `package-lock.json`, `composer.json`,
and `composer.lock`. These are kept in `deps/`. When the Castopod Host source is
updated, they must be updated as well as an additional step. A script for doing
this is provided by the flake, and can be run via `nix run .#update-nixified-deps`.
