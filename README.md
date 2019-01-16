[![Build Status](https://travis-ci.org/nodenv/nodenv-package-rehash.svg?branch=master)](https://travis-ci.org/nodenv/nodenv-package-rehash)

# nodenv-package-rehash

**Never run `nodenv rehash` again.** This nodenv plugin automatically
runs `nodenv rehash` every time you install or uninstall a global package.

<!-- toc -->

## Installation

Install the plugin:

    git clone https://github.com/nodenv/nodenv-package-rehash.git "$(nodenv root)"/plugins/nodenv-package-rehash

Install hooks for your existing nodenv versions.
(This will be done automatically for any node you install henceforth.)

    nodenv package-hooks install --all

### Tweak nodenv installation _(optional)_

With this plugin, rehashing will happen on-demand (when global npm modules are installed/uninstalled).
You can take advantage of this and remove nodenv's _automatic_ hashing upon [shell initialization](https://github.com/nodenv/nodenv#how-nodenv-hooks-into-your-shell).
In your shell startup file (`.bash_profile`, `.bashrc`, or `.zshrc`), add the `--no-rehash` flag to the `nodenv init -` invocation:

    eval "$(nodenv init - --no-rehash)"
    
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

1. no arg: applies the command only to the currently active node version (regardless how that version is set)
2. version-name: a whitespace-separate list of 1 or more explicit versions (e.g. 0.10.24)
3. `--all`: applies the command to all installed versions


## How It Works

nodenv-package-rehash consists of two parts: an npm postinstall (and
postuninstall) hook script and a nodenv plugin.

The npm script hooks into npm's `postinstall` and `postuninstall` lifecycle
events (corresponding to `npm install -g` and `npm uninstall -g`) to run
`nodenv rehash`, ensuring newly installed package executables are visible to
nodenv.

The nodenv plugin is responsible for installing the npm hook script. It
relies on nodenv's `install` hook to copy the hook script into node's global
`node_modules/hooks`.

## Credits

Forked from [Joshua Peek](https://github.com/josh)'s
[rbenv-gem-rehash](https://github.com/rbenv/rbenv-gem-rehash) by 
[Jason Karns](https://github.com/jasonkarns) and modified for nodenv.
