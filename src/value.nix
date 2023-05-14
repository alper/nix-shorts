let
  pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
  name = "test.txt";
  src = ./test.txt;
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/test
    ln -s $src $out/test/text.txt
  '';
}