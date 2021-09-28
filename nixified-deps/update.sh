#!/bin/sh

nix shell github:NixOS/nixpkgs/nixos-unstable#nodePackages.node2nix --command \
    node2nix --input package.json \
             --lock package-lock.json \
             --output nixified-deps/node-packages.nix \
             --composition nixified-deps/node-composition.nix \
             --node-env nixified-deps/node-env.nix

nix shell github:NixOS/nixpkgs/nixos-unstable#nix-prefetch-scripts ~/repos/composer2nix --show-trace --command \
    composer2nix --config-file composer.json \
                 --lock-file composer.lock \
                 --no-dev \
                 --output nixified-deps/php-packages.nix \
                 --composition nixified-deps/php-composition.nix \
                 --composer-env nixified-deps/composer-env.nix
