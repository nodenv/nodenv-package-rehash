# shellcheck shell=bash

BATS_TMPDIR=test/tmp
load ../node_modules/bats-support/load
load ../node_modules/bats-assert/load
load ../node_modules/bats-mock/stub

# common nodenv setup
unset NODENV_VERSION NODENV_DIR

PATH=/usr/bin:/bin:/usr/sbin:/sbin
PATH=$BATS_TEST_DIRNAME/../node_modules/.bin:$PATH
PATH=$BATS_TEST_DIRNAME/helpers/bin:$PATH
PATH=$BATS_TEST_DIRNAME/../bin:$PATH
PATH=$BATS_MOCK_BINDIR:$PATH
export PATH

export NODENV_ROOT=$BATS_TMPDIR/nodenv_root
mkdir -p "$NODENV_ROOT"

export NODENV_HOOK_PATH=$BATS_TEST_DIRNAME/../etc/nodenv.d

hookdir() {
  local version=$1
  echo "$NODENV_ROOT/versions/$version/lib/node_modules/.hooks"
}

teardown() {
  rm -rf "$NODENV_ROOT"
  rm -rf "$BATS_MOCK_TMPDIR"
}

# Creates fake version directories
create_versions() {
  for v in "$@"; do
    echo "Created version: $v"
    mkdir -p "$NODENV_ROOT/versions/$v"
  done
}

assert_package_hooks() {
  local version="$1"
  assert [ -f "$(hookdir "$version")/postinstall" ]
  assert [ -f "$(hookdir "$version")/postuninstall" ]
}

refute_package_hooks() {
  local version="$1"
  refute [ -f "$(hookdir "$version")/postinstall" ]
  refute [ -f "$(hookdir "$version")/postuninstall" ]
}

stub_hooks_for() {
  local version="$1"
  mkdir -p "$(hookdir "$version")"
  touch "$(hookdir "$version")"/postinstall
  touch "$(hookdir "$version")"/postuninstall
}
