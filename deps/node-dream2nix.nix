{ pkgs ? import <nixpkgs> { inherit system; }
, system ? builtins.currentSystem
, nodeJsVersion ? 16
, dream2nix
, src
, esbuild
}:

let
  outputs = (dream2nix.lib.init {
    inherit pkgs;
    config.projectRoot = src;
  }).makeOutputs {
    source = src;
    packageOverrides = {
      esbuild = {
        "add-binary-0.12.12" = {
          _condition = pkg: pkg.version == "0.12.12";
          ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
        };
      };
      castopod-host = {
        "build" = {
          buildInputs = old: with pkgs; old ++ [
            nodePackages.svgo
          ];
          postInstall = ''
            npm run build
            ln -sf ${pkgs.nodePackages.svgo}/node_modules/.bin/svgo $out/lib/node_modules/.bin
            npm run build:static
          '';
        };
      };
    };
    settings = [
      {
        subsystemInfo.npmArgs = "--ignore-scripts";
        subsystemInfo.nodejs = nodeJsVersion;
      }
    ];
  };
in
  outputs.packages.castopod-host
