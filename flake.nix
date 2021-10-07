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
        CI_ENVIRONMENT = "development"

        app.forceGlobalSecureRequests = false

        app.baseURL = "http://localhost:8080/"
        app.mediaBaseURL = "http://localhost:8080/"

        app.adminGateway = "cp-admin"
        app.authGateway = "cp-auth"

        database.default.hostname = "localhost"
        database.default.database = "castopod"
        database.default.username = "podlibre"
        # database.default.password = "castopod"

        cache.handler = "file"
      '';

      package =
        { inShell ? false
        , envFile ? defaultEnvFile
        , stateDir ? "/var/lib/castopod-host"
        , pkgs
        }:
        let
          inherit (pkgs) callPackage substituteAll applyPatches writeText lib
                         fetchFromGitHub buildGoModule git nodePackages stdenv;
          inherit (builtins) toPath;
          patchedCleanSrc = applyPatches {
            name = "castopod-source";
            src = nix-filter.lib {
              root = ./.;
              exclude = [".git" ".env" "result" "flake.nix" "flake.lock" "nix"];
            };
            patches = [(substituteAll { src = ./nix/stateDir.patch; inherit stateDir; })];
          };
          nodeComp = import ./nix/node-composition.nix { inherit pkgs; };
          esbuild = buildGoModule rec {
            pname = "esbuild";
            version = "0.12.12";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              sha256 = "sha256-4Ooadv8r6GUBiayiv4WKVurUeRPIv6LPlMhieH4VL8o=";
            };
            vendorSha256 = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          };
          npmPackage = nodeComp.package.override {
            src = patchedCleanSrc;
            npmFlags = "--ignore-scripts";
            ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
            postInstall = ''
              npm run build
              npm run build:static
            '';
          };
          phpPackage = callPackage ./nix/php-composition.nix {
            noDev = true;
            packageOverrides."podlibre/ipcat" = oldPkg: applyPatches {
              src = oldPkg;
              patches = [(substituteAll {
                src = ./nix/datacenters.patch;
                datacenters = "${ipcat}/datacenters.csv";
              })];
            };
          };
          envFile' = if lib.isString envFile then writeText ".env" envFile
            else if lib.isStorePath envFile then envFile
            else throw "arg `envFile` must be a string or store path";
        in
          phpPackage.overrideAttrs (initial: rec {
            name = "castopod-host-${version}";
            src = "${npmPackage}/lib/node_modules/castopod-host";
            nativeBuildInputs = initial.nativeBuildInputs or [] ++ [ git ];
            postInstall = ''
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
          inherit (pkgs) writeShellScript rsync mariadb;
          cfg = config.services.castopod-host;
          fpm = config.services.phpfpm.pools.castopod-host;
          package = pkgs.castopod-host.override {
            stateDir = cfg.stateDir;
            envFile = ''
              database.default.hostname = 'localhost'
              database.default.database = '${cfg.database}'
              database.default.username = '${cfg.user}'

              CI_ENVIRONMENT = ${if cfg.development then "development" else "production"}
              app.forceGlobalSecureRequests = ${if cfg.forceHttps then "true" else "false"}

              app.baseURL = '${cfg.baseUrl}'
              app.mediaBaseURL = '${cfg.baseUrl}'

              cache.handler = "file"

              ${cfg.extraConfig}
            '';
          };
          php = pkgs.php.withExtensions ({ enabled, all }:
            with all; enabled ++ [ intl curl mbstring gd mysqlnd ]
          );
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
            baseUrl = mkOption {
              type = types.str;
              default = "http://localhost/";
              description = "Base URL";
            };
            poolConfig = mkOption {
              type = with types; attrsOf (oneOf [ str int bool ]);
              default = {
                "pm" = "dynamic";
                "pm.max_children" = 32;
                "pm.start_servers" = 2;
                "pm.min_spare_servers" = 2;
                "pm.max_spare_servers" = 4;
                "pm.max_requests" = 500;
              };
              description = ''
                Options for the PHP pool. See the documentation on <literal>php-fpm.conf</literal>
                for details on configuration directives.
              '';
            };
            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Lines to add to the .env file.
                For more info see: https://codeigniter.com/user_guide/general/configuration.html...
              '';
            };
            adminAddr = mkOption {
              type = types.str;
              default = "admin@localhost";
              description = "Email address of the httpd server administrator";
            };
          };

          config = mkIf cfg.enable {
            nixpkgs.overlays = [ self.overlay ];
            users = {
              users.${cfg.user} = {
                group = cfg.user;
                isSystemUser = true;
                createHome = false;
              };
              groups.${cfg.user} = {};
            };
            services.phpfpm = {
              phpPackage = php;
              pools.castopod-host = {
                inherit (cfg) user;
                settings = {
                  "listen.owner" = config.services.httpd.user;
                } // cfg.poolConfig;
              };
            };
            services.httpd = {
              enable = true;
              user = cfg.user; # TODO is this a bad idea?
              extraModules = [ "rewrite" "proxy_fcgi" ];
              virtualHosts.castopod = {
                documentRoot = "${package}/public";
                extraConfig = ''
                  <Directory "${package}/public">
                    <FilesMatch "\.php$">
                      <If "-f %{REQUEST_FILENAME}">
                        SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
                      </If>
                    </FilesMatch>
                    Options Indexes FollowSymLinks
                    AllowOverride All
                    DirectoryIndex index.php
                    Require all granted
                  </Directory>
                '';
                adminAddr = cfg.adminAddr;
              };
            };
            services.mysql = {
              enable = true;
              package = mkDefault mariadb;
              ensureDatabases = [ cfg.database ];
              ensureUsers = [{
                name = cfg.user;
                ensurePermissions = { "${cfg.database}.*" = "ALL PRIVILEGES"; };
              }];
            };
            systemd =
              let prep = "castopod-host-prep";
                  periodic = "castopod-host-scheduled-activities";
              in {
                services = {
                  ${prep} = {
                    description = "Castopod-host prep";
                    wantedBy = [ "multi-user.target" ];
                    requires = [ "mysql.service" ];
                    after = [ "mysql.service" ];
                    path = [ rsync php ];
                    serviceConfig = {
                      Type = "oneshot";
                      User = cfg.user;
                      PermissionsStartOnly = true;
                      WorkingDirectory = package;
                      ExecStartPre = writeShellScript "castopod-host-prep-statedir" ''
                        rsync -ru ${package}/writable/ ${cfg.stateDir}/
                        rsync -ru ${package}/public/~media/ ${cfg.stateDir}/media/
                        chown -R ${cfg.user} ${cfg.stateDir}
                        chmod -R 770 ${cfg.stateDir}
                      '';
                      ExecStart = writeShellScript "castopod-host-init-db" ''
                        php spark migrate -all
                        php spark db:seed AppSeeder
                      '';
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
                  requires = [ "${prep}.service" ];
                  after = [ "${prep}.service" ];
                  timerConfig = {
                    OnActiveSec = "0";
                    OnUnitActiveSec = "60";
                    Unit = [ "${periodic}.service" ];
                  };
                };
              };
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
            networking.firewall.allowedTCPPorts = [ 80 443 ];

            # Enable the castopod service
            services.castopod-host = {
              enable = true;
              development = false;
              baseUrl = "http://castopod/";
              # adminAddr = "admin@localhost";
            };
          })
        ];
      };


      # TODO Tests run by 'nix flake check' and by Hydra
    };
}
