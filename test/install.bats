#!/usr/bin/env bats

load test_helper

export INSTALL_HOOK="${BATS_TEST_DIRNAME}/../etc/nodenv.d/install/install-pkg-hooks.bash"

@test "running nodenv-install auto installs hook scripts" {
  stub nodenv-prefix '0.10.36 : echo "$NODENV_ROOT/versions/0.10.36"'
  run nodenv-install 0.10.36

  assert_success
  assert_line 'Installed fake version 0.10.36'
  assert_line 'Installed postinstall/postuninstall package hooks for 0.10.36'
  assert_package_hooks 0.10.36
}