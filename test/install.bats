#!/usr/bin/env bats

load test_helper

@test "running nodenv-install auto installs hook scripts" {
  run nodenv install 0.10.36

  assert_success
  assert_line 'Installed fake version 0.10.36'
  assert_line 'Installed postinstall/postuninstall package hooks for 0.10.36'
  assert_package_hooks 0.10.36
}

@test "a failed nodenv-install exits hook script gracefully" {
  run nodenv install fail 0.10.36

  assert_failure
  assert_line 'Failed installation of 0.10.36'
  refute_line 'Installed postinstall/postuninstall package hooks for 0.10.36'
  refute_package_hooks 0.10.36
}
