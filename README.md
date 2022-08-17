# Castopod Host

This repository is a Nix flake that packages Castopod Host
([source](https://code.podlibre.org/podlibre/castopod-host), [website](https://castopod.org/)),
a free and open source podcast hosting solution. The flake interface provides
several potential points of contact, including:
- the server alone as a package
- an overlay adding that package to a package set (IE nixpkgs)
- a NixOS module that runs the server and some other services it requires
- a NixOS container configuration that serves as an example of using the module

## Updating

The castopod-host source is a flake input, and can be updated via
`nix flake lock --update-input castopod-host-src`.

Unfortunately, it is also necessary to maintain Nix expressions in this repo that represent the php dependencies specified in the source repo's `composer.json`,
and `composer.lock` files. These are kept in `deps/`.
When the Castopod Host source is updated, they must be updated as well as an additional step. A script for doing this is provided by the flake, and can be run via `nix run .#update-nixified-deps`.

The nodejs dependencies specified in the repo's `package.json` and
`package-lock.json` are resolved by
[dream2nix](https://github.com/nix-community/dream2nix), and as such
they do not need any extra setup or updates: dream2nix can use the
`package-lock.json` file directly and resolve the pinned dependencies
during the build.
