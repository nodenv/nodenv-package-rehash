#!/usr/bin/env bash

set -e
[ -n "$NODENV_DEBUG" ] && set -x

NODE_DIR="${1:-$(nodenv prefix)}"
NPM_HOOKS_DIR="$NODE_DIR/lib/node_modules/.hooks"

mkdir -p "$NPM_HOOKS_DIR"


# install the postinstall/postuninstall hook scripts by symlinking them
ln -nsf "${BASH_SOURCE%/*}/../libexec/nodenv-rehash.sh" "${NPM_HOOKS_DIR}/postinstall"
ln -nsf "${BASH_SOURCE%/*}/../libexec/nodenv-rehash.sh" "${NPM_HOOKS_DIR}/postuninstall"
