#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts nodePackages.node2nix

node2nix --input package.json \
         --lock package-lock.json \
         --development \
         --output nix/node-packages.nix \
         --composition nix/node-composition.nix \
         --node-env nix/node-env.nix

nix shell github:charlieshanley/composer2nix --command \
    composer2nix --config-file composer.json \
                 --lock-file composer.lock \
                 --no-dev \
                 --output nix/php-packages.nix \
                 --composition nix/php-composition.nix \
                 --composer-env nix/composer-env.nix
