{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    ipcat = {
      url = "github:client9/ipcat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ipcat }:
    let

      # Generate a user-friendly version numer
      version = "${builtins.substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";
      # version = "v1.0.0-alpha.70"; # TODO automate grabbing of this version

      # System types to support
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types with package overlaid
      nixpkgsBySystem = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      });

      package =
        { inShell ? false
        # , stdenv
        , callPackage
        , substituteAll
        , applyPatches
        , git
        , php
        }:
        (callPackage ./nixified-deps/php-composition.nix {
          noDev = true;
          packageOverrides = {
            "podlibre/ipcat" = oldPkg: applyPatches {
              src = oldPkg;
              patches = [(substituteAll {
                src = ./nixified-deps/datacenters.patch;
                datacenters = "${ipcat}/datacenters.csv";
              })];
            };
          };
        }).overrideAttrs (initial: rec {
          src = ./.;
          nativeBuildInputs = initial.nativeBuildInputs or [] ++ [ git ];
        });
        # stdenv.mkDerivation rec {
        #   pname = "castopod-host";
        #   inherit version;

        #   src = ./.;

        #   nodeDeps = (callPackage ./node2nix {}).nodeDependencies;

        #   # composerDeps = c4.fetchComposerDeps { inherit src; };

        #   # TODO .env file
        #   # TODO php configuration

        #   nativeBuildInputs = [
        #     # nodejs
        #     # php.packages.composer
        #     # c4.composerSetupHook
        #   ];

        #   installPhase = ''
        #     runHook preInstall

        #     mkdir -p $out/share/castopod-host
        #     # composer install
        #     ln -s ${nodeDeps}/lib/node_modules ./node_modules
        #     cp -r . $out/share/castopod-host

        #     runHook postInstall
        #   '';
        # };

      forAttrs = attrs: f: nixpkgs.lib.mapAttrs f attrs;

    in {

      # A Nixpkgs overlay that adds the package
      overlay = final: prev: {
        castopod-host = with final; callPackage package {};
      };

      # The package built against the specified Nixpkgs version
      packages = forAttrs nixpkgsBySystem (_: pkgs: {
        inherit (pkgs) castopod-host;
      });

      # The default package for 'nix build'
      defaultPackage = forAttrs self.packages (_: pkgs: pkgs.castopod-host);

      # A 'nix develop' environment for interactive hacking
      devShell = forAttrs self.packages (_: pkgs: pkgs.castopod-host.override { inShell = true; });

      # A NixOS module
      nixosModules.castopod-host = { config, pkgs, lib, ... }:
        let
          inherit (lib) mkEnableOption mkIf;
          cfg = config.services.castopod-host;
        in
        {
          nixpkgs.overlays = [ self.overlay ];

          options.services.castopod-host = {
            enable = mkEnableOption "castopod-host";
          };

          config = mkIf cfg.enable {
            systemd.services.castopod-host = {
              wantedBy = [ "multi-user.target" ];
              serviceConfig.ExecStart = "${pkgs.castopod-host}/bin/castopod-host";
            };
          };
        };

      # TODO configuration for container/machine running the module

      # TODO Tests run by 'nix flake check' and by Hydra
    };
}
