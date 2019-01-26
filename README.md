[![Build Status](https://travis-ci.org/nodenv/nodenv-package-rehash.svg?branch=master)](https://travis-ci.org/nodenv/nodenv-package-rehash)

# nodenv-package-rehash

**Never run `nodenv rehash` again.** 

This nodenv plugin automatically
runs `nodenv rehash` every time you install or uninstall a global package.

<!-- toc -->

- [Installation](#installation)
  * [install via git *(recommended)*](#install-via-git-recommended)
  * [install via homebrew](#install-via-homebrew)
  * [install via npm](#install-via-npm)
- [Configuration *(optional)*](#configuration-optional)
- [Usage](#usage)
  * [Subcommands](#subcommands)
- [How It Works](#how-it-works)
- [Caveats](#caveats)
- [Credits](#credits)

<!-- tocstop -->

## Installation

After installation, you should have a `nodenv package-hooks` subcommand,
and the package-rehash hook should be included in the output of
`nodenv hooks install`.

Then you may install the hooks for your existing nodenv versions.
(This will be done automatically for any node you install henceforth.)

  ```sh
  nodenv package-hooks install --all
  ```

### install via git *(recommended)*

Install the plugin:

  ```sh
  git clone https://github.com/nodenv/nodenv-package-rehash.git "$(nodenv root)"/plugins/nodenv-package-rehash
  ```

### install via homebrew

  ```sh
  brew install nodenv/nodenv/nodenv-package-rehash
  ```

### install via npm

  ```sh
  npm i -g @nodenv/nodenv-package-rehash
  ```

This method is not recommended, because of the likelihood that the nodenv plugin gets installed under a node being _managed_ by nodenv.
If using this method, it is highly recommended to install the plugin into your `system` node.

Also note, this package requires a package level npm postinstall hook to ensure the nodenv-install hook is found by `nodenv hooks install`.
If you install this package with lifecycle hooks disabled, you will need to do this manually either by a one-time symlink:

  ```sh
  ln -s "$(npm -g prefix)/lib/node_modules/@nodenv/nodenv-package-rehash/etc/nodenv.d/install/install-pkg-hooks.bash" "$(nodenv root)/nodenv.d/install/package-rehash.bash
  ```

or by configuring `NODENV_HOOK_PATH` in your shell startup:

  ```sh
  export NODENV_HOOK_PATH=$(npm -g prefix)/lib/node_modules/@nodenv/nodenv-package-rehash/etc/nodenv.d/:$NODENV_HOOK_PATH
  ```

## Configuration *(optional)*

With this plugin, rehashing will happen on-demand (when global npm modules are installed/uninstalled).
You can take advantage of this and remove nodenv's _automatic_ hashing upon [shell initialization][].
In your shell startup file (`.bash_profile`, `.bashrc`, or `.zshrc`), add the `--no-rehash` flag to the `nodenv init -` invocation:

  ```sh
  eval "$(nodenv init - --no-rehash)"
  ```

This will speed up your shell initialization since nodenv will no longer need to rehash on every startup.

## Usage

1. `npm install -g` a package that provides executables.
2. Marvel at how you no longer need to type `nodenv rehash`.

### Subcommands

Three sub commands are available for manual hook management.

1. `nodenv package-hooks list [ --all | <version-name>... ]`

    Lists any hooks installed for the given version(s)

2. `nodenv package-hooks install [ --all | <version-name>... ]`

    Installs postinstall/postuninstall rehash hooks for the given version(s)

3. `nodenv package-hooks uninstall [ --all | <version-name>... ]`

    Uninstalls postinstall/postuninstall rehash hooks for the given version(s)

All three sub commands accept similar arguments:

1. no arg: applies the command only to the currently active node version
2. version-name: a whitespace-separate list of 1 or more explicit versions (e.g. 0.10.24)
3. `--all`: applies the command to all installed versions


## How It Works

nodenv-package-rehash consists of two parts:
an npm postinstall (and postuninstall) hook script and a nodenv plugin.

The npm script hooks into npm's `postinstall` and `postuninstall` lifecycle events
(corresponding to `npm install -g` and `npm uninstall -g`) to run `nodenv rehash`,
ensuring newly installed package executables are visible to nodenv.

The nodenv plugin is responsible for installing the npm hook script.
It relies on nodenv's `install` hook to copy the npm hook script into node's global `node_modules/.hooks/`.

For users who install this plugin via npm, there is also a package postinstall hook
which will install the nodenv-install hook into the `NODENV_HOOK_PATH`.

## Caveats

Automatic rehashing after installation of global packages does _not_ work with versions of npm `^5.1.0 || ~6.0.1`.
If you use one of the affected versions of npm,
you will need to run `nodenv rehash` manually after installing global packages.
It is recommended to upgrade to a version of npm 6.1.0 or later (or stay on a version prior to 5.1.0).

npm version 5.1.0 [broke global package hooks][issue] ([npm/cli@e084987][npm-cli]) and they remained broken until 6.1.0 ([npm/npm-lifecycle#13][npm-lifecycle]).
Node versions 8.2.0 through 10.2.1 (inclusive) ship with affected versions of npm.

## Credits

Inspired by [Joshua Peek][]'s [rbenv-gem-rehash][].

[Joshua Peek]: https://github.com/josh
[shell initialization]: https://github.com/nodenv/nodenv#how-nodenv-hooks-into-your-shell
[rbenv-gem-rehash]: https://github.com/rbenv/rbenv-gem-rehash
[issue]: https://npm.community/t/npm-version-5-broke-local-and-global-lifecycle-hooks/4857
[npm-cli]: https://github.com/npm/cli/commit/e084987
[npm-lifecycle]: https://github.com/npm/npm-lifecycle/pull/13
