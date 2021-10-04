#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-scripts nodePackages.node2nix

# Add two dev deps to deps so that we can use them without building all dev deps,
# some of which don't work
cat package-lock.json \
    | jq '.packages."".dependencies += {svgo: .packages."".devDependencies.svgo, "cpy-cli": .packages."".devDependencies."cpy-cli"}' \
    > nix/package-lock.json
cat package.json \
    | jq '.dependencies += {svgo: .devDependencies.svgo, "cpy-cli": .devDependencies."cpy-cli"}' \
    > nix/package.json

node2nix --input nix/package.json \
         --lock nix/package-lock.json \
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
