# Developing and Building with Flakes

## What is a Flake?

Flakes are ‘new’ and experimental and have been like that for a couple of years. It looks like they'll be stabilized soon now since they are a very popular way to use Nix.

It's possible to do pretty much any type of configuration using the flake format, but we'll limit ourselves here to two closely related applications. We put a `flake.nix` file in a project folder and use the definition in the file to setup a development environment for that environment and perform the build of that project.

```nix
# src/flakes/flake.nix
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
          necessary_packages = [ pkgs.llvmPackages_14.clang ];
        in
        with pkgs;
        {
          packages.default = pkgs.stdenv.mkDerivation {
            name = "clang-hello";
            src = ./.;
            buildInputs = [] ++ necessary_packages;

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

            TEST_ENV = "TEST";
          };

          devShells.default = mkShell {
            packages = [] ++ necessary_packages;

            shellHook = ''
            echo "Shell!"
            '';
          };
        }
      );
}
```

There's a bunch of stuff going on in here.

This is one of the most basic possible flakes that does something non-trivial. The default output in `packages.default` is a minimal derivation to bulid this single file C project.

The derivation is passed a `name`, and the location where the `src` can be found for the project. In a lot of cases this location will be the same directory and it will be written in Nix as `./.` ([paths are literals in Nix](https://nix.dev/tutorials/first-steps/nix-language#file-system-paths)).

Then we take the `necessary_packages` and append it to `buildInputs` here. In this case we'll compile the file with the Clang compiler which is in there.

Then the build happens which consists of a series of [phases documented in the manual](https://nixos.org/manual/nixpkgs/stable/#build-phase). The default behaviour of these phases is to call `./configure; make; make install`, if those files happen to exist.

For languages where builds don't use those tools there are many language specific overlays that will handle the standard build process and hide away the plumbing.

Because it's a bit of a hassle to generate all the relevant files for an [automake C project](https://thoughtbot.com/blog/the-magic-behind-configure-make-make-install), we're writing our own `buildPhase` and `installPhase` here with shell commands (these go between the two single quotes). In the `buildPhase` we compile and link the source code. In the `installPhase` we move the resulting executable `hello` to `$out`, the location where Nix has determined the result of this derivation should live.

The bit about `flake-utils.lib.eachDefaultSystem` is not something you need to understand now but you'll run into it a lot. What it does in short is that it creates the same flake output for each default system. You can see the result of that in `nix flake show` below.

Let's look at this in action.

## nix build

Go to the `./src/flakes/` directory here and run `nix build`. This will grab the `flake.nix` file by convention and build the `packages.default` (transformed into `packages.${system}.default`) in the flake.

```bash
$ cd src/flakes
$ nix build
$ ls

…
lrwxr-xr-x   1 alpercugun  staff    55 May 18 20:42 result@ -> /nix/store/qgfiq7cpcpbj4qa4bv4lbfw9zrq6wsd4-clang-hello
…

$ ./result/bin/hello
Hello World
```

The output is in the Nix store from where it is symlinked to our current directory so we can easily access it and run it.

Running `nix build` again is very fast because as long as the inputs haven't changed, Nix won't do anything here.

## nix develop

In the same folder you can run `nix develop` and will then enter the shell defined in [`mkShell`](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell). `mkShell` creates a derivation that has some extra facilities to create a shell.

This shell gets the same packages as our build which in this case means Clang is provided for us.

```bash
$ nix develop
Shell!
(nix:nix-shell-env) $ which clang

/nix/store/fm4frncax8sd0pcs5sq4yc2mnkz3r6li-clang-wrapper-14.0.6/bin/clang
```

There's also a shell hook there for demonstration purchases that prints "Shell!" when we enter the shell.

You can also directly run a command in the given shell like this: `nix develop --command clang`

## Commands

* `nix flake show`

Shows the outputs of a flake. Useful for figuring what is happening.

For our example this returns:

```
git+file:///Users/alpercugun/Documents/projects/nix-shorts?dir=src
├───devShells
│   ├───aarch64-darwin
│   │   └───default: development environment 'nix-shell'
│   ├───aarch64-linux
│   │   └───default: development environment 'nix-shell'
│   ├───x86_64-darwin
│   │   └───default: development environment 'nix-shell'
│   └───x86_64-linux
│       └───default: development environment 'nix-shell'
└───packages
    ├───aarch64-darwin
    │   └───default: package 'clang-hello'
    ├───aarch64-linux
    │   └───default: package 'clang-hello'
    ├───x86_64-darwin
    │   └───default: package 'clang-hello'
    └───x86_64-linux
        └───default: package 'clang-hello'
```

* `nix flake check`

Checks whether the flake can be evaluated and gives feedback on things that may be wrong.

* `nix flake metadata`

Shows a bunch of metadata about the flake.

* `nix flake update`

Updates all the inputs that go into the flake and creates a new `flake.lock` file with those.

* `nix build --debug`

Returns very detailed output about the build process. Useful for debugging.

## Links

* [Practical Nix Flakes](https://serokell.io/blog/practical-nix-flakes)
* [A first Nix package definition](https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/first-package.html)
* [Basic Dependencies and Hooks](https://nixos.org/guides/nix-pills/basic-dependencies-and-hooks.html), some terse documentation on `buildInputs` and other parts of `mkDerivation`
* [flake-utils](https://github.com/numtide/flake-utils)
* [Why you don't need flake-utils](https://ayats.org/blog/no-flake-utils/), details about what flake-utils does
* [Reproducible Shell environments via Nix Flakes](https://www.softwarefactory-project.io/reproducible-shell-environments-via-nix-flakes.html)
* [Flakes wiki page](https://nixos.wiki/wiki/Flakes)