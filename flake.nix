{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # composer2nix = {
    #   url = "github:jbboehr/composer2nix/php-arg-in-default";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs }:
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

      package = { inShell ? false, pkgs }:
        with pkgs;
        stdenv.mkDerivation rec {
          pname = "castopod-host";
          inherit version;

          src = ./.;

          node-deps = (callPackage ./node2nix {}).nodeDependencies;

          # TODO .env file
          # TODO php configuration

          nativeBuildInputs = [
            nodejs
          ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/castopod-host
            cp -r . $out/share/castopod-host
            ln -s ${node-deps}/lib/node_modules $out/share/castopod-host/node_modules

            runHook postInstall
          '';
        };

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
