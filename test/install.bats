#!/usr/bin/env bats

load test_helper

# integration-y test that go through nodenv itself,
# but use a fake nodenv-install from test/helpers/bin

@test "nodenv install hook installs npm hook scripts" {
  run nodenv install 0.10.36

  assert_success
  assert_line 'Installed fake version 0.10.36'
  assert_line 'Installed postinstall/postuninstall package hooks for 0.10.36'
  assert_package_hooks 0.10.36
}

@test "nodenv install hook exits gracefully after failed node install" {
  run nodenv install fail 0.10.36

  assert_failure
  assert_line 'Failed installation of 0.10.36'
  refute_line 'Installed postinstall/postuninstall package hooks for 0.10.36'
  refute_package_hooks 0.10.36
}

@test "installing a node with buggy npm (8.2.0-10.2.1) emits warning" {
  run nodenv install 8.2.0

  assert_success
  assert_line "(This node bundles a buggy npm that doesn't execute global hooks.)"
}

@test "installing a node with non-buggy npm (8.2.0-10.2.1) doesn't emit warning" {
  run nodenv install 10.3.0

  assert_success
  refute_line -p "buggy npm"
}
