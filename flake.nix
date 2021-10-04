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

        database.default.hostname="localhost"
        database.default.database="castopod"
        database.default.username="podlibre"
        # database.default.password="castopod"

        # cache.handler="redis"
        # cache.redis.host = "redis"
        cache.handler="file"
      '';

      package =
        { inShell ? false
        , envFile ? defaultEnvFile
        , stateDir ? "/var/lib/castopod-host"
        , pkgs
        }:
        let
          inherit (pkgs) callPackage substituteAll applyPatches writeText lib
                         fetchFromGitHub git nodePackages;
          nodeDeps = (import ./nix/node-composition.nix { inherit pkgs; })
            .nodeDependencies.override (_: {
              src = nix-filter.lib { root = ./.; include = [ "package.json" "package-lock.json" ]; };
            });
          envFile' = if lib.isString envFile then writeText ".env" envFile
            else if lib.isStorePath envFile then envFile
            else throw "arg `envFile` must be a string or store path";
        in (callPackage ./nix/php-composition.nix {
          noDev = true;
          packageOverrides = {
            "podlibre/ipcat" = oldPkg: applyPatches {
              src = oldPkg;
              patches = [(substituteAll {
                src = ./nix/datacenters.patch;
                datacenters = "${ipcat}/datacenters.csv";
              })];
            };
          };
        }).overrideAttrs (initial: rec {
          name = "castopod-host-${version}";
          src = applyPatches {
            name = "source";
            src = nix-filter.lib {
              root = ./.;
              exclude = [".git" "result" "flake.nix" "flake.lock" "nix"];
            };
            patches = [
              (substituteAll { src = ./nix/stateDir.patch; inherit stateDir; })
            ];
          };
          nativeBuildInputs = initial.nativeBuildInputs or [] ++ [ git nodePackages.npm ];
          postInstall = ''
            ln -s ${nodeDeps}/lib/node_modules $out/node_modules
            export PATH="${nodeDeps}/bin:$PATH"
            echo $PATH
            npm run build:static

            ln -s ${envFile'} $out/.env

            mv $out/public/media $out/public/~media
            ln -s ${stateDir}/media $out/public/media
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
          inherit (lib) mkOption mkEnableOption mkIf mkDefault types;
          inherit (pkgs) castopod-host writeShellScript php rsync mariadb;
          cfg = config.services.castopod-host;
          package = castopod-host.override {
            stateDir = cfg.stateDir;
            envFile = ''
              database.default.hostname="localhost"
              database.default.database="${cfg.database}"
              database.default.username="${cfg.user}"

              ${if cfg.development then "CI_ENVIRONMENT=\"development\"" else ""}
              app.forceGlobalSecureRequests=${if cfg.forceHttps then "true" else "false"}

              ${cfg.extraConfig}
            '';
          };
        in
        {
          options.services.castopod-host = {
            enable = mkEnableOption "castopod-host";
            stateDir = mkOption {
              type = types.path;
              default = "/var/lib/castopod-host";
              description = ''
                Path for Castopod-host to use as the readable/writable state directory
              '';
            };
            database = mkOption {
              type = types.str;
              default = "castopod";
              description = "Database name";
            };
            user = mkOption {
              type = types.str;
              default = "podlibre";
              description = "Unix user corresponding to database user";
            };
            development = mkOption {
              type = types.bool;
              default = false;
              description = "Run CodeIgniter in development mode";
            };
            forceHttps = mkOption {
              type = types.bool;
              default = false;
              description = "If true, redirects all http requests to use https";
            };
            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Lines to add to the .env file.
                For more info see: https://codeigniter.com/user_guide/general/configuration.html...
              '';
            };
          };

          config = mkIf cfg.enable {
            nixpkgs.overlays = [ self.overlay ];
            systemd =
              let primary = "castopod-host";
                  prep = "castopod-host-prep";
                  periodic = "castopod-host-scheduled-activities";
              in {
                services = {
                  ${prep} = {
                    description = "Castopod-host prep";
                    wantedBy = [ "multi-user.target" ];
                    path = [ rsync ];
                    serviceConfig = {
                      Type = "oneshot";
                      ExecStart = writeShellScript "prep-castopod-host" ''
                        rsync -ru ${package}/writable/ ${cfg.stateDir}/
                        rsync -ru ${package}/public/~media/ ${cfg.stateDir}/media/
                        chown -R ${cfg.user} ${cfg.stateDir}
                        chmod -R 700 ${cfg.stateDir}
                      '';
                    };
                  };
                  ${primary} = {
                    description = "Castopod-host server";
                    wantedBy = [ "multi-user.target" ];
                    requires = [ "${prep}.service" "mysql.service" ];
                    after = [ "${prep}.service" "mysql.service" ];
                    serviceConfig = {
                      User = cfg.user;
                      WorkingDirectory = package;
                      ExecStartPre = writeShellScript "castopod-host-init-db" ''
                        ${php}/bin/php spark migrate -all
                        ${php}/bin/php spark db:seed AppSeeder
                      '';
                      ExecStart = "${php}/bin/php spark serve --host 0.0.0.0";
                    };
                  };
                  ${periodic} = {
                    description = "Castopod-host scheduled activities";
                    serviceConfig = {
                      Type = "oneshot";
                      User = cfg.user;
                      WorkingDirectory = package;
                      ExecStart = "${php}/bin/php public/index.php scheduled-activities";
                    };
                  };
                };
                timers.${periodic} = {
                  description = "Timer for Castopod-host scheduled activities";
                  wantedBy = [ "timers.target" ];
                  requires = [ "${primary}.service" ];
                  after = [ "${primary}.service" ];
                  timerConfig = {
                    OnActiveSec = "0";
                    OnUnitActiveSec = "60";
                    Unit = [ "${periodic}.service" ];
                  };
                };
              };
            users.users.${cfg.user} = {
              group = cfg.user;
              isSystemUser = true;
              createHome = false;
            };
            services.mysql = { # mkIf cfg.database.createLocally {
              enable = true;
              package = mkDefault mariadb;
              ensureDatabases = [ cfg.database ];
              ensureUsers = [{
                name = cfg.user;
                ensurePermissions = { "${cfg.database}.*" = "ALL PRIVILEGES"; };
              }];
            };


            # services.httpd = {
            #   enable = true;
            #   adminAddr = "admin@localhost";
            #   enablePHP = true;
            #   virtualHosts.localhost.documentRoot = "${castopod-host}/public";
            # };
          };
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
            networking.firewall.allowedTCPPorts = [ 8080 ];

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
