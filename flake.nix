{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    castopod-host-src = {
      url = "git+https://code.podlibre.org/podlibre/castopod-host?ref=alpha";
      flake = false;
    };
    composer2nix.url = "github:charlieshanley/composer2nix";
    ipcat = {
      url = "github:client9/ipcat";
      flake = false;
    };
    podcastNamespace = {
      url = "github:Podcastindex-org/podcast-namespace/main";
      flake = false;
    };
    userAgents = {
      url = "github:opawg/user-agents";
      flake = false;
    };
    podcastRssUserAgents = {
      url = "github:opawg/podcast-rss-useragents";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , castopod-host-src
    , composer2nix
    , ipcat
    , podcastNamespace
    , userAgents
    , podcastRssUserAgents
    }:
    let

      # Generate a user-friendly version numer
      version = "${builtins.substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";

      # System types to support
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types with package overlaid
      nixpkgsBySystem = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [
          self.overlay
          (final: prev: { update-nixified-deps = final.callPackage update-nixified-deps {}; })
        ];
      });

      # It's a shame this is necessary. Alas. Run this after updating the
      # castopod-host-src input: `nix run .#update-nixified-deps`
      update-nixified-deps = { system, nodePackages, nix-prefetch-scripts, writeShellScriptBin }:
        let n2n = "${nodePackages.node2nix}/bin";
            c2n = "${composer2nix.defaultPackage.${system}}/bin";
            nps = "${nix-prefetch-scripts}/bin";
        in writeShellScriptBin "update-nixified-dependencies" ''
             export PATH=${n2n}:${c2n}:${nps}:$PATH
             pushd deps
             cp ${castopod-host-src}/package.json \
                ${castopod-host-src}/package-lock.json \
                ${castopod-host-src}/composer.json \
                ${castopod-host-src}/composer.lock \
                ./
             node2nix --input package.json \
                      --lock package-lock.json \
                      --development \
                      --output node-packages.nix \
                      --composition node-composition.nix \
                      --node-env node-env.nix
             composer2nix --config-file composer.json \
                          --lock-file composer.lock \
                          --no-dev \
                          --output php-packages.nix \
                          --composition php-composition.nix \
                          --composer-env composer-env.nix
             popd
           '';

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
                         fetchFromGitHub buildGoModule git nodePackages stdenv
                         imagemagick msmtp rsync runCommand;
          inherit (builtins) toPath map removeAttrs;
          # This is a separate drv because of idiosyncrasies in the *2nix builds
          patchedSrc = applyPatches {
            name = "castopod-host-src";
            src = castopod-host-src;
            patches = [
              (substituteAll { src = ./patches/stateDir.patch; inherit stateDir; })
              (substituteAll { src = ./patches/podcastNamespace.patch; inherit podcastNamespace; })
            ];
          };
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
          npmPackage = (callPackage ./deps/node-composition.nix {}).package.override {
            src = patchedSrc;
            npmFlags = "--ignore-scripts";
            ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
            postInstall = ''
              npm run build
              npm run build:static
            '';
          };
          envFile' = writeText ".env" ''
            images.libraryPath = "${imagemagick}/bin/convert"
            email.mailPath = "${msmtp}/bin/sendmail"
            ${envFile}
          '';
          patchFun = { patches, ... }@args:
            let extraArgs = removeAttrs args [ "patches" ];
                subbedPatches = map (p: substituteAll ({ src = p; } // extraArgs)) patches;
            in x: applyPatches { src = x; patches = subbedPatches; };
          phpPackage = (callPackage ./deps/php-composition.nix {
            noDev = true;
            packageOverrides = {
              "podlibre/ipcat" = patchFun {
                patches = [ ./patches/ipcat.patch ];
                inherit ipcat;
              };
              "opawg/user-agents-php" = patchFun {
                patches = [ ./patches/userAgents.patch ];
                inherit userAgents podcastRssUserAgents;
              };
            };
          }).overrideAttrs (initial: {
            src = patchedSrc;
            nativeBuildInputs = initial.nativeBuildInputs or [] ++ [ git ];
          });
        in
          # Compose the npm and php packages together
          runCommand "castopod-host-${version}" {} ''
            mkdir $out
            ${rsync}/bin/rsync -a ${npmPackage}/lib/node_modules/castopod-host/ ${phpPackage}/ $out
            chmod -R +w $out

            ln -s ${envFile'} $out/.env
            mv $out/public/media $out/public/~media
            ln -s ${stateDir}/media $out/public/media
          '';

      forAttrs = attrs: f: nixpkgs.lib.mapAttrs f attrs;

    in {

      # A Nixpkgs overlay that adds the package
      overlay = final: prev: { castopod-host = final.callPackage package {}; };

      # The package built against the specified Nixpkgs version
      packages = forAttrs nixpkgsBySystem (_: pkgs: {
        inherit (pkgs) castopod-host update-nixified-deps;
      });

      # The default package for 'nix build'
      defaultPackage = forAttrs self.packages (_: pkgs: pkgs.castopod-host);

      # A 'nix develop' environment for interactive hacking
      devShell = forAttrs self.packages (_: pkgs: pkgs.castopod-host.override { inShell = true; });

      # A NixOS module
      nixosModules.castopod-host = { config, pkgs, lib, ... }:
        let
          inherit (lib) mkOption mkEnableOption mkIf mkDefault types;
          inherit (pkgs) writeShellScript writeText rsync mariadb;
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
              app.mediaBaseURL = '${cfg.mediaBaseUrl}'

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
            superadmin = {
              username = mkOption {
                type = types.str;
                description = ''
                  Username of the initial superadmin that will be created in the
                  database if no users exist yet.
                '';
              };
              email = mkOption {
                type = types.str;
                description = ''
                  Email address of the initial superadmin that will be created in the
                  database if no users exist yet.
                '';
              };
              initialPassword = mkOption {
                type = types.str;
                default = "password";
                description = ''
                  Initial password for the superadmin that is created in the
                  database if no prior users exist.
                  This password is not secure and should be changed immediately
                  on first use.
                '';
              };
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
            mediaBaseUrl = mkOption {
              type = types.str;
              default = config.services.castopod-host.baseUrl;
              description = ''
                Media base URL. If not provided, baseUrl is used. If you had a
                CDN for audio files, you would put that URL here.
              '';
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
            phpOptions = mkOption {
              type = types.lines;
              default = "";
              description = "Lines to be added to php.ini for the pool serving the app";
            };
            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Lines to add to the .env file.
                For more info see: https://codeigniter.com/user_guide/general/configuration.html,
                and also see https://code.podlibre.org/podlibre/castopod-host/-/tree/alpha/app/Config
                for app-specific configuration values that can be set.
              '';
              example = ''
                email.fromEmail = admin@my-domain.com
                email.fromName = Podcast Admin
                email.SMTPHost = smtp.my-domain.com
                email.SMTPUser = smtpusername
                email.SMTPPass = smtppassword
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
                inherit (cfg) user phpOptions;
                settings = {
                  "listen.owner" = config.services.httpd.user;
                } // cfg.poolConfig;
              };
            };
            services.httpd = {
              enable = true;
              user = cfg.user;
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
                    path = [ rsync php mariadb ];
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

                        export nUsers=$(mariadb -Bse "select count(*) from cp_users;" ${cfg.database})
                        if [[ $nUsers -lt 1 ]]
                          then
                            php spark auth:create_user ${cfg.superadmin.username} ${cfg.superadmin.email}
                            php spark auth:set_password ${cfg.superadmin.username} ${cfg.superadmin.initialPassword}
                            mariadb castopod < ${writeText "make-superadmin" ''
                              insert into cp_auth_groups_users (group_id, user_id)
                              select cp_auth_groups.id, cp_users.id
                              from cp_auth_groups, cp_users
                              where cp_auth_groups.name = "superadmin"
                              and cp_users.username = "${cfg.superadmin.username}";
                            ''}
                        fi
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
              phpOptions = ''
                post_max_size = 50M
                upload_max_filesize = 40M
              '';
              superadmin = {
                username = "superadmin";
                email = "superadmin@example.com";
              };
            };

            environment.systemPackages = with pkgs; [
              tmux vim htop tree php80
            ];
          })
        ];
      };


      # TODO Tests run by 'nix flake check'
    };
}
