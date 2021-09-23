{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    npm-buildpackage.url = "github:serokell/nix-npm-buildpackage";
    # npmlock2nix = {
    #   url = "github:tweag/npmlock2nix";
    #   flake = false;
    # };
    # composer2nix = {
    #   url = "github:jbboehr/composer2nix/php-arg-in-default";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, npm-buildpackage }:
    let

      # Generate a user-friendly version numer
      version = "${builtins.substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";
      # # TODO automate
      # version = "v1.0.0-alpha.70";

      # System types to support
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types with package overlaid
      nixpkgsBySystem = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [
          self.overlay
          npm-buildpackage.overlay
          # (final: prev: { nodejs = final.nodejs-16_x; })
        ];
      });

      package = { inShell ? false, pkgs }:
        with pkgs;
        stdenv.mkDerivation rec {
          pname = "castopod-host";
          inherit version;

          src = ./.;

          node2nix-expr = runCommandNoCC "node2nix-${pname}" {
            buildInputs = [ git ];
          } ''
            mkdir $out
            ${nodePackages.node2nix}/bin/node2nix \
              --input ${src}/package.json \
              --lock ${src}/package-lock.json \
              --node-env $out/node-env.nix \
              --output $out/node-packages.nix \
              --composition $out/default.nix \
          '';

          node-dependencies =
            (import node2nix-expr { inherit pkgs; inherit (pkgs) nodejs; }).nodeDependencies;

          # TODO .env file
          # TODO php configuration

          nativeBuildInputs = [
            nodejs
          ];

          # node-modules = mkNodeModules {
          #   inherit src pname version;
          #   packageOverrides = {};
          #   extraEnvVars = {};
          # };

          installPhase = ''
            runHook preInstall


            mkdir -p $out/share/castopod-host
            cp -r . $out/share/castopod-host
            cp -r ${node-dependencies} $out/share/castopod-host/node_modules

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
