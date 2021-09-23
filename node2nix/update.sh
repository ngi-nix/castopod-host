#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix \
  --input package.json \
  --lock package-lock.json \
  --output node2nix/node-packages.nix \
  --composition node2nix/default.nix \
  --node-env node2nix/node-env.nix


