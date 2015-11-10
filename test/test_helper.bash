load ../node_modules/bats-assert/all
load ../node_modules/bats-mock/stub

export TMP="$BATS_TEST_DIRNAME/tmp"

NODENV_TEST_DIR="${BATS_TMPDIR}/nodenv"
mkdir -p "${NODENV_TEST_DIR}"

export NODENV_ROOT="${NODENV_TEST_DIR}"

PATH=/usr/bin:/bin:/usr/sbin:/sbin
PATH="$BATS_TEST_DIRNAME/helpers/bin:$PATH"
PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
PATH="$TMP/bin:$PATH"
PATH="$BATS_MOCK_BINDIR:$PATH"
export PATH

teardown() {
  rm -rf "$NODENV_TEST_DIR"
  rm -rf "$TMP"
}

# Creates fake version directories
create_versions() {
  for v in $*
  do
    echo "Created version: $v"
    d="$NODENV_TEST_DIR/versions/$v"
    mkdir -p "$d/bin"
    ln -nfs /bin/echo "$d/bin/node"
  done
}


assert_package_hooks() {
  version="$1"
  test -f "$NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postinstall"
  test -f "$NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postuninstall"
}

refute_package_hooks() {
  version="$1"
  test ! -f "$NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postinstall"
  test ! -f "$NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postuninstall"
}
