{pkgs ? import <nixpkgs> {
    inherit system;
  }, system ? builtins.currentSystem, noDev ? false, packageOverrides ? {}}:

let
  composerEnv = import ./composer-env.nix {
    inherit (pkgs) stdenv lib writeTextFile fetchurl unzip;
    php = pkgs.php80;
    phpPackages = pkgs.php80Packages;
  };
in
import ./php-packages.nix {
  inherit composerEnv noDev packageOverrides;
  inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn;
}
