{ pkgs
, dream2nix
, src
, system ? builtins.currentSystem
, nodeJsVersion ? 16
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
          ESBUILD_BINARY_PATH =
            let
              esbuild = pkgs.buildGoModule rec {
                pname = "esbuild";
                version = "0.12.12";
                src = pkgs.fetchFromGitHub {
                  owner = "evanw";
                  repo = "esbuild";
                  rev = "v${version}";
                  sha256 = "sha256-4Ooadv8r6GUBiayiv4WKVurUeRPIv6LPlMhieH4VL8o=";
                };
                vendorSha256 = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
              };
            in "${esbuild}/bin/esbuild";
        };
      };
      castopod-host = {
        "build" = {
          buildScript = ''
            npm run build
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
