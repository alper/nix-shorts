# nix-shorts

![](./logo.png)

A collection of short notes about [Nix](https://nixos.org/), boiled down to what is immediately needed for users.

The aim of this collection is to provide some instantly usable information with clear code demonstrations.

## Guide

While you can read the posts in this repo in any order, here's a suggestion:

* Try out installing things [temporarily into a nix-shell](posts/working-with-nix-shells.md)
* Make this permanent by [adding these packages to your profile](posts/install-things-to-nix-profile.md)
* Understand how a [simple derivation](posts/your-first-derivation.md) works and is built
* [Setup a flake](posts/develop-and-build-with-flakes.md) to easily work on a project and build it

## Requirements

### Install Nix

The best way to install Nix at the moment is with [the Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer). Details of how to install Nix using the installer are in [chapter 1 of Zero to Nix](https://zero-to-nix.com/start/install).

### Enable flakes

The articles here will be flake first and TODO

## Stylistic notes

All articles are meant to be easy enough to approach with clear examples of terminal commands, code, or file setups. When project setups are needed, appropriate directories will be in this repo and referenced.

When applicable, usernames are replaced with `your-user` and hashes replaced with `some-hash`. E.g.

```
$ readlink ~/.nix-profile
/nix/var/nix/profiles/per-user/justin/profile
$ readlink -f ~/.nix-profile
/nix/store/mwgv8fzlr6n9kkb5nyz27fv1l66jc7nf-user-environment
```

...will be shown as

```
$ readlink ~/.nix-profile
/nix/var/nix/profiles/per-user/your-user/profile
$ readlink -f ~/.nix-profile
/nix/store/some-hash-user-environment
```

## Contributing

Small fixes and elaborations can be contributed via PR. Content suggestions can be done via issues.

This guide itself is a fork of [Justin's original](https://github.com/justinwoo/nix-shorts) with a large number of updates and changes.

This document intentionally simplifies and omits a large part of the Nix ecosystem. Contributions will need to follow suit.

## Resources

Here are some clear and well-written tutorials that can be found around the web:

* [Zero to Nix](https://zero-to-nix.com/), a whirlwind tour of the kind of things you can do with Nix
* [Using Nix with Dockerfiles](https://mitchellh.com/writing/nix-with-dockerfiles), Mitchell Hashimoto writes a guide how to use Nix and Dockerfiles to containerize a small Python Flask app
* [Some notes on using nix](https://jvns.ca/blog/2023/02/28/some-notes-on-using-nix/) and [How do Nix builds work?](https://jvns.ca/blog/2023/03/03/how-do-nix-builds-work-/), Julia Evans explains how she uses Nix (without flakes) on macOS to build software
* [Building a Rust service with Nix](https://fasterthanli.me/series/building-a-rust-service-with-nix), Amos writes a guide how to containerize and deploy a realistic Rust application both without Nix and with Nix (from part 9 on)

## FAQ

### Why not Nix Pills?

Readers of [Nix Pills](https://nixos.org/nixos/nix-pills/) should well know that the purpose of the Nix Pills are clearly stated multiple times in its contents:

> These articles are not a tutorial on using Nix. Instead, we're going to walk through the Nix system to understand the fundamentals.
