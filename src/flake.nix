{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          buildInputs = [ pkgs.llvmPackages_14.clang ];
        in
        with pkgs;
        {
          packages.default = pkgs.stdenv.mkDerivation {
            name = "clang-hello";
            buildInputs = [] ++ buildInputs;
            src = ./.;

            buildPhase = ''
            clang -c hello.c
            clang -o hello hello.o
            '';

            # We could also do only `mv hello $out` and have result be a
            # symlink to the executable file directly
            installPhase = ''
            mkdir -p $out/bin
            mv hello $out/bin
            '';
          };

          devShells.default = mkShell {
            packages = [] ++ buildInputs;

            shellHook = ''
            echo "Shell!"
            '';
          };
        }
      );
}