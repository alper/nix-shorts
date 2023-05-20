# Inspecting values with Nix REPL

When working with Nix expressions, it can be useful to inspect some values involved.

In these cases, the Nix REPL can be pretty useful.

## Some specific REPL forms

When you open up a REPL, you can use `:?` to see the specific REPL forms, e.g.:

```bash
bash> nix repl

Welcome to Nix 2.13.3. Type :? for help.

nix-repl> :?
The following commands are available:

  <expr>        Evaluate and print expression
  <x> = <expr>  Bind expression to variable
  :a <expr>     Add attributes from resulting set to scope
  :b <expr>     Build derivation
  :i <expr>     Build derivation, then install result into current profile
  :l <path>     Load Nix expression and add it to scope
  # ...
```

The top three entries will be the most useful for us.

### Evaluate

The first is the same as an expression evaluation:

```bash
nix-repl> 1
1
```

### Bind

The second is the same as a `let`-bind in an expression:

```bash
nix-repl> a = 1

nix-repl> a
1
```

This is equivalent to `let a = 1; in ...`, but the introduced variables will persist in the session.

### Add attributes to scope

The third is the same as a `with` in an expression:

```bash
nix-repl> :a { hello = "bye"; }
Added 1 variables.

nix-repl> hello
"bye"
```

This is the same as `with { hello = "bye"; }; hello`.

Chances are, you probably won't want to use this one often, as you may end up with a scope full of random identifiers you do not want to use. However, this can be useful at least when you are using builtins:

```bash
nix-repl> :a builtins
Added 101 variables.

nix-repl> attrNames { hello = 1; bye = 2; }
[ "bye" "hello" ]
```

## Using the REPL with `<nixpkgs>`

Using the REPL with nixpkgs is one of the most common usages of the REPL. From here, you can inspect what packages are available, specific packages' versions, and try launching a Nix Shell with these packages.

```bash

bash> nix repl '<nixpkgs>' # or `nix repl your-pinned-nixpkgs.nix`

Loading installable ''...
Added 19036 variables.
```

For the most part, what you will find most useful is being able to tab-complete, e.g.:

```bash
nix-repl> pk<TAB>
pk2cmd              pkgconfig           pkgsBuildTarget     pkgsStatic
pkcs11helper        pkgconfigUpstream   pkgsCross           pkgsTargetTarget
pkg-config          pkgs                pkgsHostHost        pkgsi686Linux
pkg-configUpstream  pkgsBuildBuild      pkgsHostTarget      pktgen
pkgconf             pkgsBuildHost       pkgsMusl
```

### Building derivations

```bash
nix-repl> :?
  # ...
  :b <expr>     Build derivation
  :t <expr>     Describe result of evaluation
  :u <expr>     Build derivation, then start nix-shell

nix-repl> :t pkgs.purescript
a set

nix-repl> :u pkgs.purescript
these paths will be fetched (5.57 MiB download, 43.87 MiB unpacked):
  /nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0
copying path '/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0' from 'https://cache.nixos.org'...

nix-shell> which purs
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/bin/purs

nix-shell> purs --version
0.13.0
```

We can also build derivations from here and produce the out path.

```bash
nix-repl> pkgs.purescript.outPath
"/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0"

nix-repl> :b pkgs.purescript

this derivation produced the following outputs:
  out -> /nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0

bash> fd . /nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/bin
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/bin/purs
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/etc
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/etc/bash_completion.d
/nix/store/vmwdvr9fcrbvnfdjfrrpb07z8gzbi1q7-purescript-0.13.0/etc/bash_completion.d/purs-completion.bash
```

If you find that you want to install these packages to your profile, you can use `:i` to do so. From `:?`:

```bash
nix-repl> :?
  # ...
  :b <expr>     Build derivation
  :i <expr>     Build derivation, then install result into current profile
  :l <path>     Load Nix expression and add it to scope
  :s <expr>     Build dependencies of derivation, then start nix-shell
  :u <expr>     Build derivation, then start nix-shell
```

## Links

* Nix wiki on REPL: <https://nixos.wiki/wiki/Nix-repl>
