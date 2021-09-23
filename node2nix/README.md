This directory contains nix expressions generated from `package.json` and
`package-lock.json`. They represent the JS dependencies in a nix-friendly way,
and are used to generate `node_modules` in the build described by `flake.nix`.

These expressions should be kept up-to-date by running `node2nix/update.sh` (from
the project root dir) after `package-lock.json` changes. The script requires nix
to be installed, but other than that provisions its own dependencies thanks to
the nix-shell shebang.

This method works, but is inconvenient in that it requires a manual step and
for somewhat redundant files to be committed to the repo. There are other
methods that wouldn't require these, but I have not yet gotten one to work.
They are:
  - using IFD (import from derivation) to invoke `node2nix` to generate these
    expressions, and then to import them, all during the evaluation of `flake.nix`.
    This has the same result as the method currently used without the manual step,
    but the IFD doesn't work in restricted mode and requires `nix build --impure`.
    See [example](https://gist.github.com/sorki/e23c3462f60e0b6a1eaa7d9fc3ac5480).
  - `npmlock2nix` and `nix-npm-buildpackage` are other tools that parse `package.json`
    and `package-lock.json` and provide a derivation for `node_modules` without
    needing to manually generate files before-hand, but both fail when trying to
    install `esbuild`, which is a dependency of the dev-dependency `vite`. This
    ought to be fixable for `nix-npm-buildpackage` via `packageoverrides`. This
    problem does not afflict `node2nix` because it does not build the
    dev-dependencies unless we ask it to.
