load helpers/assertions/all

export TMP="$BATS_TEST_DIRNAME/tmp"

NODENV_TEST_DIR="${BATS_TMPDIR}/nodenv"
mkdir -p "${NODENV_TEST_DIR}"

export NODENV_ROOT="${NODENV_TEST_DIR}"
export INSTALL_HOOK="${BATS_TEST_DIRNAME}/../etc/nodenv.d/install/install-hook-scripts.sh"

PATH=/usr/bin:/bin:/usr/sbin:/sbin
PATH="$BATS_TEST_DIRNAME/../bin:$PATH"
PATH="$TMP/bin:$PATH"
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

stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift

  export "${prefix}_STUB_PLAN"="${TMP}/${program}-stub-plan"
  export "${prefix}_STUB_RUN"="${TMP}/${program}-stub-run"
  export "${prefix}_STUB_END"=

  mkdir -p "${TMP}/bin"
  ln -sf "${BATS_TEST_DIRNAME}/helpers/stub" "${TMP}/bin/${program}"

  touch "${TMP}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${TMP}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${TMP}/bin/${program}"

  export "${prefix}_STUB_END"=1

  local STATUS=0
  "$path" || STATUS="$?"

  rm -f "$path"
  rm -f "${TMP}/${program}-stub-plan" "${TMP}/${program}-stub-run"
  return "$STATUS"
}
