# Pinning to a specific Nixpkgs revision

When you work with various packages from Nixpkgs that change often or might not be available in a specific version you want, you should pin a specific revision of Nixpkgs.

## Fetching Nixpkgs

If you fetch and import some revision of the `nixos/nixpkgs` repo from GitHub, you will have a drop-in replacement for `<nixpkgs>` that you often use in some revision.

For example,

```nix
# pinned.nix
import (
  builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/dca38e06e92e48eef7bcd5449b4207eb1d628f14.tar.gz";
    sha256 = "some-sha"; # Not sure where to get this on Github
  }
)
```

This expression uses the GitHub tarballs created for each publicly visible commit, using the builtin fetchTarball in Nix 2.x+.

Once you have this, you can consume it as usual.

```bash
$ nix run hello -f pinned.nix
Hello, world!
```

## Usage

In your expressions, you can simply replace usages of `<nixpkgs>` with your imported NixPkgs expression.

```diff
-{ pkgs ? import <nixpkgs> {} }:
+{ pkgs ? import ./pinned.nix {} }:
```

## More convenient usage

While fetching the tarball directly is fine, this can be a bit arduous to work with when you want to update some expressions automatically (e.g. with [update-prefetch](https://github.com/justinwoo/update-prefetch)).

While you could use `builtins.fetchGit`, you'll soon find that it is very expensive to have to fetch the Nixpkgs git repository due to how Git works.

However, you can use `fetchFromGitHub` from Nixpkgs instead to make life easier, which will use the GitHub tarball archives directly and save you from very time consuming operations.

```nix
let
  pkgs = import <nixpkgs> {};
in
import (
  pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "some-commit-hash";
    sha256 = "some-sha";
  }
)
```

## Links

* NixOS Wiki on pinning Nixpkgs: <https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs>
