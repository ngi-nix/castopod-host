{
  description = "A free and open-source podcast hosting solution made for podcasters who want engage and interact with their audience";

  # Nixpkgs / NixOS version to use
  inputs.nixpkgs.url = "nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }:
    let

      # Generate a user-friendly version numer
      # version = "${builtins.substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";
      version = "v1.0.0-alpha.70";

      # System types to support
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types with package overlaid
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in {

      # A Nixpkgs overlay that adds the package
      overlay = final: prev: {

        castopod-host = with final; final.callPackage ({ inShell ? false }: stdenv.mkDerivation rec {
          name = "castopod-host-${version}";

          # In 'nix develop', we don't need a copy of the source tree in the Nix store
          src = if inShell then null else ./.;

          buildInputs = [ 
          ] ++ (if inShell then [
            # In 'nix develop', provide some developer tools
          ] else [
          ]);

        }) {};

      };

      # The package built against the locked Nixpkgs version
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) castopod-host;
      });

      # The default package for 'nix build'
      defaultPackage = forAllSystems (system: self.packages.${system}.castopod-host);

      # A 'nix develop' environment for interactive hacking
      devShell = forAllSystems (system: self.packages.${system}.castopod-host.override { inShell = true; });

      # A NixOS module
      nixosModules.castopod-host =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];

          systemd.services.castopod-host = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${pkgs.castopod-host}/bin/castopod-host";
          };
        };

      # TODO configuration for container/machine running the module

      # TODO Tests run by 'nix flake check' and by Hydra
      # checks = forAllSystems
      #   (system:
      #     with nixpkgsFor.${system};

      #     {
      #       inherit (self.packages.${system}) castopod-host;

      #       # A VM test of the NixOS module
      #       vmTest =
      #         with import (nixpkgs + "/nixos/lib/testing-python.nix") {
      #           inherit system;
      #         };

      #         makeTest {
      #           nodes = {
      #             client = { ... }: {
      #               imports = [ self.nixosModules.castopod-host ];
      #             };
      #           };

      #         testScript =
      #           ''
      #             start_all()
      #             client.wait_for_unit("multi-user.target")
      #             assert "Hello Nixers" in client.wait_until_succeeds("curl --fail http://localhost:8080/")
      #           '';
      #         };
      #     }
      #   );
    };
}
