# Allow the nixpkgs import to be overridden if desired
{ pkgs ? import <nixpkgs> {} }:

# Let's write an actual basic derivation
# This uses the standard nixpkgs mkDerivation function
pkgs.stdenv.mkDerivation {

  # Name of the derivation
  name = "hello-derivation";

  # Sources that will be used for the derivation.
  src = ./.;

  # $src is defined as the location of the `src` attribute above
  installPhase = ''
    # $out is an automatically generated filepath by nix,
    # but it's up to you to make it what you need. We'll create a directory at
    # that filepath, then copy the sources into it.
    mkdir -p $out
    cp -rv $src/* $out
  '';
}