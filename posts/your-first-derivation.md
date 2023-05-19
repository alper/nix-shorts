# Your First Derivation

## What is a derivation?

A derivation in Nix is a definition of a build, which takes some inputs and produces an output. The inputs are usually in a `src` attribute, and the output is a path in the Nix store like this: `/nix/store/some-hash-pkg-name`.

Building a derivation will create a symlink called `result` to the output in the current directory.

## Basic derivation example

Start with some inputs you want to build with.

```bash
$ cd src/derivation

$ ls
hi.txt

$ cat hello.txt
Hello!
```

Then prepare a `default.nix`, which is the file that `nix-build` will look for.

```nix
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
```

Some notes about this that you should know.

### Nix files are expressions

Every Nix source file must be a valid expression. In this case, `default.nix` is a function expression. The function takes an attribute set, provides a default value for `pkgs`, and then returns a derivation value by calling the function `mkDerivation` provided by the  `stdenv` package in `pkgs`.

When this file is called with `nix-build`, the function will be called automatically with the default argument unless it's overridden.

### Derivations must have names

This is satisfied by the `name` attribute defined above.

### Derivations created with `mkDerivation` must have sources

This is satisfied by using the relative path `./.` above.

### Derivations made with `mkDerivation` use the concept of "phases"

In this derivation, we only needed to define the `installPhase` to override the default from the generic builder. You can see more details about the build phases here: <https://nixos.org/nixpkgs/manual/#sec-stdenv-phases>

### Why use the nixpkgs `stdenv.mkDerivation`?

While derivation can be written from scratch using the builtin function `derivation`, the reality is that there are many standardized steps to a build that should be handled.

That's why most derivations you work with when using Nix will be created by `mkDerivation` and it should be the one you learn first.

## Building the derivation

With the derivation defined, we can build this derivation using `nix-build`.

```bash
$ nix-build # or nix-build default.nix
# some build logs
/nix/store/rmzsbw9mspwqv59x3rvc4j440az065sp-hello-derivation
```

This output path is simply where the Nix Store output has been created. `nix-build` will create a symlink to the output by default in `./result`. You can inspect the symlink and contents to see that the output is indeed just a symlink to a directory where all the inputs have been copied into just as we specified in `installPhase`.

```bash
$ readlink result
/nix/store/52aqgvlsc6mvy1px0h488xw9yd25l043-hello-derivation

$ ls result/
default.nix  hello.txt    result@

$ cat result/hello.txt
Hello!
```

## Links

* [Phases in the Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)
* [Hacking Your First Package](https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/first-package.html)
