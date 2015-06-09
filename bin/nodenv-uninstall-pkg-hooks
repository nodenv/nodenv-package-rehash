#!/usr/bin/env bash

set -e
[ -n "$NODENV_DEBUG" ] && set -x

NODE_DIR="$(nodenv-prefix "$1")"
NPM_HOOKS_DIR="$NODE_DIR/lib/node_modules/.hooks"

# remove postinstall/postuninstall hook scripts
rm "${NPM_HOOKS_DIR}/postinstall"
rm "${NPM_HOOKS_DIR}/postuninstall"
