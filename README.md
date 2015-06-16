# nodenv-package-rehash

**Never run `nodenv rehash` again.** This nodenv plugin automatically
runs `nodenv rehash` every time you install or uninstall a global package.

## Installation

    git clone https://github.com/jasonkarns/nodenv-package-rehash.git $(nodenv root)/plugins/nodenv-package-rehash

## Usage

1. `npm install -g` a package that provides executables.
2. Marvel at how you no longer need to type `nodenv rehash`.

### Subcommands

Three sub commands are available for manual hook management.

1. `nodenv package-hooks list [version-name... | -all]
    Lists any hooks installed for the given version(s)
2. `nodenv package-hooks install [version-name... | -all]
    Installs postinstall/postuninstall rehash hooks for the given version(s)
3. `nodenv package-hooks uninstall [version-name... | -all]
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
