#!/usr/bin/env bash

set -e
[ -n "$NODENV_DEBUG" ] && set -x

NPM_HOOKS_DIR="$(nodenv prefix)/lib/node_modules/.hooks"

# remove postinstall/postuninstall hook scripts
rm "${NPM_HOOKS_DIR}/postinstall"
rm "${NPM_HOOKS_DIR}/postuninstall"
