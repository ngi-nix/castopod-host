{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    ipcat = {
      url = "github:client9/ipcat";
      flake = false;
    };
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, ipcat, nix-filter }:
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

      defaultEnvFile = ''
        CI_ENVIRONMENT="development"

        app.forceGlobalSecureRequests=false

        app.baseURL="http://localhost:8080/"
        app.mediaBaseURL="http://localhost:8080/"

        app.adminGateway="cp-admin"
        app.authGateway="cp-auth"

        database.default.hostname="mariadb"
        database.default.database="castopod"
        database.default.username="podlibre"
        database.default.password="castopod"

        # cache.handler="redis"
        # cache.redis.host = "redis"
        cache.handler="file"
      '';

      package =
        { inShell ? false
        , git
        , callPackage
        , substituteAll
        , applyPatches
        , writeText
        , envFile ? defaultEnvFile
        , lib
        , pkgs
        }:
        let
          nodeDeps = (import ./nixified-deps/node-composition.nix { inherit pkgs; })
            .nodeDependencies.override (_: {
              src = nix-filter.lib { root = ./.; include = [ "package.json" "package-lock.json" ]; };
            });
          envFile' = if lib.isString envFile then writeText ".env" envFile
            else if lib.isStorePath then envFile
            else throw "arg `envFile` must be a string or store path";
        in (callPackage ./nixified-deps/php-composition.nix {
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
          name = "castopod-host-${version}";
          src = nix-filter.lib {
            root = ./.;
            exclude = [".git" "result" "flake.nix" "flake.lock" "nixified-deps"];
          };
          nativeBuildInputs = initial.nativeBuildInputs or [] ++ [ git ];
          postInstall = ''
            ln -s ${nodeDeps}/lib/node_modules $out/node_modules
            ln -s ${envFile'} $out/.env
          '';
        #   # TODO php configuration
        });

      forAttrs = attrs: f: nixpkgs.lib.mapAttrs f attrs;

    in {

      # A Nixpkgs overlay that adds the package
      overlay = final: prev: { castopod-host = final.callPackage package {}; };

      # The package built against the specified Nixpkgs version
      packages = forAttrs nixpkgsBySystem (_: pkgs: { inherit (pkgs) castopod-host;});

      # The default package for 'nix build'
      defaultPackage = forAttrs self.packages (_: pkgs: pkgs.castopod-host);

      # A 'nix develop' environment for interactive hacking
      devShell = forAttrs self.packages (_: pkgs: pkgs.castopod-host.override { inShell = true; });

      # A NixOS module
      nixosModules.castopod-host = { config, pkgs, lib, ... }:
        let
          inherit (lib) mkOption mkEnableOption mkIf types;
          cfg = config.services.castopod-host;
        in
        {
          options.services.castopod-host = {
            enable = mkEnableOption "castopod-host";
            envFile = mkOption {
              type = with types; either string path; # TODO attrsOf str?
              default = defaultEnvFile;
              description = ''
                File or string with contents of a .env file.
                For more info see: https://codeigniter.com/user_guide/general/configuration.html...
              '';
            };
          };

          config = mkIf cfg.enable
            (let castopod-host = pkgs.castopod-host.override {
                 };
            in {
              nixpkgs.overlays = [ self.overlay ];

              # systemd.services.castopod-host = {
              #   wantedBy = [ "multi-user.target" ];
              #   serviceConfig.ExecStart = "${pkgs.castopod-host}/bin/castopod-host";
              # };
              services.httpd = {
                enable = true;
                adminAddr = "admin@localhost";
                enablePHP = true;
                virtualHosts.localhost.documentRoot = "${pkgs.castopod-host}/public";
              };
            });
        };

      # configuration for container that runs the module
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.castopod-host
          ({ pkgs, ... }: {
            boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = pkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 ];

            # Enable the castopod service
            services.castopod-host = {
              enable = true;
            };
          })
        ];
      };


      # TODO Tests run by 'nix flake check' and by Hydra
    };
}
