{ pkgs
, dream2nix
, src
, ipcat
, userAgents
, podcastRssUserAgents
, system ? builtins.currentSystem
}:

let
  inherit (pkgs) substituteAll applyPatches;

  outputs = (dream2nix.lib.init {
    inherit pkgs;
    config.projectRoot = ../.;
  }).makeOutputs {
    source = src;
    settings = [
      { subsystemInfo.noDev = true; }
    ];
    packageOverrides = {
      "podlibre/castopod-host" = {
        run-post-install-cmd = {
          postBuild = ''
            composer run-script post-install-cmd
          '';
        };
      };
    };
    sourceOverrides = orig: {
      "podlibre/ipcat"."v1.0" = applyPatches {
        name = "podlibre/ipcat";
        src = orig."podlibre/ipcat"."v1.0";
        patches = [
          (substituteAll {
            src = ../patches/ipcat.patch;
            inherit ipcat;
          })
        ];
      };
      "opawg/user-agents-php"."v1.0" = applyPatches {
        name = "opawg/user-agents-php";
        src = orig."opawg/user-agents-php"."v1.0";
        patches = [
          (substituteAll {
            src = ../patches/userAgents.patch;
            inherit userAgents podcastRssUserAgents;
          })
        ];
      };
    };
  };
in
  outputs.packages."podlibre/castopod-host"
