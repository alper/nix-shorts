# Working with Nix Shell

Nix shells give you an ephemeral shell environment with packages installed for you to use. This is useful to try out things and with `mkShell` you can describe and recreate such an environment whenever you need it.

The `nix-shell` command is an old style command with a dash in between. During the transition to the next version of Nix, there's no way around these commands and it's good to at least know that they exist.

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

But instead of only top level attributes, you can also put entire expressions in the `-p` argument. This is more of an advanced use, but it's included here so that you've seen it once.

For example, with the [easy-purescript-nix](https://github.com/justinwoo/easy-purescript-nix/) project:

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

Instead of having the expression passed on the command line, `nix-shell` will load the expression from a file. If no file is passed explicitly, `nix-shell` will look for either a file named `shell.nix` or a file named `default.nix` in that order.

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
