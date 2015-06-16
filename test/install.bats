#!/usr/bin/env bats

load test_helper

@test "running nodenv-install auto installs hook scripts" {

  nodenv-install 0.10.36
  # run nodenv-install 0.10.36
  assert_success
  assert_line 'Installed fake version 0.10.36'
  assert_line 'Installed postinstall/postuninstall hook scripts'

  assert_hook_script postinstall
  assert_hook_script postuninstall
}
