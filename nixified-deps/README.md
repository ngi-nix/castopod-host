This directory contains nix expressions generated from `package.json`,
`package-lock.json`, `composer.json`, and `composer.lock`. They represent dependencies
in a nix-friendly way, and are used to generate `node_modules` and `vendor` in
the build described by `flake.nix`.

These expressions should be kept up-to-date by running `nixified-deps/update.sh`
(from the project root dir). The script requires flakes-enabled nix to be installed,
but other than that provisions its own dependencies.

This method works, but is inconvenient in that it requires a manual step and
for somewhat redundant files to be committed to the repo. There are other
methods that wouldn't require these, but I have not yet gotten them to work because
a) they would require IFD in the flake, and that requires `nix build --impure` to
succeed, or b) issues with getting a certain JS dependency to build.
