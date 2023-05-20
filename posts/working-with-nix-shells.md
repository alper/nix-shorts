# Working with Nix Shell

Nix shells are quite useful for a number of different reasons, but the main reason is that it can provide you programs you want at specific versions.

## Shells with `-p`

Using `nix-shell` with `-p` can get you quickly set up with a shell with packages from NixPkgs installed.

```bash
$ nix-shell -p hello

# nix sub shell with hello installed
[nix-shell:~/nix-shorts]$ which hello
/nix/store/some-hash-hello-2.10/bin/hello

[nix-shell:~/nix-shorts]$ hello
Hello, world!

[nix-shell:~/nix-shorts]$ exit
exit

# back to your top level shell
$
```

### Expressions as arguments

But instead of only top level attributes, you can also put entire expressions in the `-p` argument. For example, with the [easy-purescript-nix](https://github.com/justinwoo/easy-purescript-nix/) project:

```bash
$ nix-shell \
     -p 'let ep = import ./default.nix {}; in [ ep.purs ep.spago ]' \
    --run 'which purs; which spago; purs --version; spago version'
/nix/store/some-hash-purescript/bin/purs
/nix/store/some-hash-spago/bin/spago
0.13.3
0.9.0.0
```

As mentioned before, we can use Nix shells to get specific versions of packages.

```bash
$ nix-shell -p '(import ./default.nix {}).purs' --run 'which purs; purs --version'
/nix/store/some-hash-purescript/bin/purs
0.13.3
```

```bash
$ nix-shell -p '(import ./default.nix {}).purs-0_13_0' --run 'which purs; purs --version'
/nix/store/some-hash-purescript/bin/purs
0.13.0
```

## Nixpkgs mkShell

To work with Nix shells in some organized manner, you probably will want to use a source-controlled file defining a derivation. To make this concise and explicit, you can use `mkShell` from Nixpkgs.

Note that `nix-shell` will use files with an agreed upon name in the current directory. It will look for a `shell.nix` file first and if that doesn't exist, a `default.nix` file will be used.

```nix
# shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.hello ];
}
```

And we can see this used like this:

```console
$ nix-shell --run 'which hello; hello' # implicitly does `nix-shell shell.nix --run ...`
/nix/store/some-hash-hello-2.10/bin/hello
Hello, world!
```

## Links

* [Nix manual nix-shell](https://nixos.org/nix/manual/#sec-nix-shell)
* [NixPkgs manual mkShell](https://nixos.org/nixpkgs/manual/#sec-pkgs-mkShell)
