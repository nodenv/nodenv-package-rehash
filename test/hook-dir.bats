#!/usr/bin/env bats

load test_helper

libexec=$BATS_TEST_DIRNAME/../libexec

fake_npm_env() {
  export npm_config_argv='{"remain":["@nodenv/nodenv-package-rehash"],"cooked":["i","@nodenv/nodenv-package-rehash"],"original":["i","@nodenv/nodenv-package-rehash"]}'
  cd $BATS_TEST_DIRNAME/..
}

assert_nodenv_hook_installed() {
  [ -L "$1/install/package-rehash.bash" ]
}

@test "npm doesn't install nodenv hook when running bare install" {
  fake_npm_env
  npm_config_argv='{"remain":[],"cooked":["i"],"original":["i"]}'

  run $libexec/install-nodenv-hook

  assert_success
  refute_output
}

@test "npm installs nodenv hook to NODENV_HOOK_PATH when set" {
  fake_npm_env
  export NODENV_HOOK_PATH=$BATS_TMPDIR/hooks
  mkdir -p $NODENV_HOOK_PATH

  run $libexec/install-nodenv-hook

  assert_success
  assert_nodenv_hook_installed "$NODENV_HOOK_PATH"
  assert_output "nodenv install hook installed to $NODENV_HOOK_PATH"
}

@test "npm installs nodenv hook to NODENV_ROOT/nodenv.d when NODENV_HOOK_PATH not set" {
  fake_npm_env
  unset NODENV_HOOK_PATH

  run $libexec/install-nodenv-hook

  assert_success
  assert_nodenv_hook_installed "$NODENV_ROOT/nodenv.d"
  assert_output "nodenv install hook installed to $NODENV_ROOT/nodenv.d"
}
