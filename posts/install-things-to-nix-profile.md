# Install things to Nix Profile

The Nix Profile is the place where you can install packages permanently so that it will still be there on a new shell.

We'll install things there using the `nix profile` subcommend. This is one of several ways to configure your environment with Nix and it is the one we'll discuss here because it's quite straight-forward.

One thing to note is that once you use `nix profile` the older `nix-env` command will no longer work. These commands are not compatible with each other.
## What is Nix Profile?

Nix Profile is a symlink location in `~/.nix-profile` when you install Nix that ultimately resolves to a location in the store.

```bash
$ readlink ~/.nix-profile
/nix/var/nix/profiles/per-user/your-user/profile

$ readlink -f ~/.nix-profile
/nix/store/some-hash-user-environment
```

Depending on what you have installed, various things will be in the directory.

```
$ ls ~/.nix-profile
bin  etc  include  lib  manifest.nix  share
```

Notice that `~/.nix-profile/bin` is in your PATH (if you have installed Nix correctly).

You will see that the directory structure in `~/.nix-profile` resembles that of a Linux file system root directory.

## How do I install packages?

To install packages from nixpkgs, you have to use `nix profile install nixpkgs#packageName`:

```bash
$ nix profile install nixpkgs#deno
evaluating derivation…

$ which deno
/Users/alpercugun/.nix-profile/bin/deno
```

You can find packages with their names to install online on the nixos packages website: https://search.nixos.org/packages

## How do I find out what is installed in my environment?

To find out what packages have been installed in your profile, you can use `nix profile list`.

```bash
$ nix profile list
…
12 flake:nixpkgs#legacyPackages.aarch64-darwin.pipenv github:NixOS/nixpkgs/ea11a3977f4cba013d8680667616be827c967ac0#legacyPackages.aarch64-darwin.pipenv /nix/store/nf3355sysvy6s4jv85kd72zzb23c7pzn-pipenv-2023.2.4
13 flake:nixpkgs#legacyPackages.aarch64-darwin.deno github:NixOS/nixpkgs/0cb867999eec4085e1c9ca61c09b72261fa63bb4#legacyPackages.aarch64-darwin.deno /nix/store/d0q09iiyf0xi79zk4z957z3bj51gh05c-deno-1.33.2
14 flake:nixpkgs#legacyPackages.aarch64-darwin.nodePackages.typescript github:NixOS/nixpkgs/0cb867999eec4085e1c9ca61c09b72261fa63bb4#legacyPackages.aarch64-darwin.nodePackages.typescript /nix/store/y3jvabiff9ffisnsx121nm7ffa3wrd3s-typescript-5.0.4
…
```

## How do I uninstall packages?

Somewhat awkwardly, you'll have to uninstall packages by their index.

So first you do `nix profile list` and see which number the package starts with that you want to remove. For `deno` in the list in the previous section that's `13`.

Then to remove it you do `nix profile remove 13`.

```bash
$ nix profile remove 13
removing 'flake:nixpkgs#legacyPackages.aarch64-darwin.deno'
```

## How do I upgrade packages?

You can upgrade your installed packages by index with `nix profile upgrade 1` or you can upgrade all of them with `nix profile upgrade '.*'`.

Don't forget to run `nix-collect-garbage` regularly to remove unused packages.

## Can I go back to a previous profile?

Nix Profile keeps track of each state that your profile was in. You can see the history of states with `nix profile history`.

If you want to go back to a previous state, you can pass the number to rollback: `nix profile rollback --to 36` and then check back in history that it put you there.

You can always go back again by putting the last number (or any other) after `--to`.

You can even see the change in closure sizes from state to state with `nix profile diff-closures`.

## Links

You can read more about nix profile and its subcommands in the excellent man pages. Use these commands:

```bash
$ nix help profile
$ nix help profile install
$ nix help profile list
$ nix help profile remove
```

* [Stop using nix-env](https://stop-using-nix-env.privatevoid.net/), "If you really need to imperatively manage some of your packages, [nix profile] is your best option."
* [nix profile — Nix Reference Manual](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-profile.html)
