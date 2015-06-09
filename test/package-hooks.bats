#!/usr/bin/env bats

load test_helper

setup() {
  create_versions 0.10 0.12
  stub nodenv-prefix ': 0.10' \
                     '0.12 : 0.12'
}

@test "nodenv-package-hooks install" {
  run nodenv-package-hooks install

  assert_success
  assert_package_hooks 0.10
  refute_package_hooks 0.12
}

@test "nodenv-package-hooks install <version>" {
  run nodenv-package-hooks install

  assert_success
  refute_package_hooks 0.10
  assert_package_hooks 0.12
}

# @test "nodenv-package-hooks uninstall" {
#   create_versions 0.10.36

#   run nodenv-alias name 0.8.5
#   assert_success
#   assert_alias_version name 0.8.5
# }

# @test "nodenv-package-hooks uninstall <version>" {
#   create_versions 0.10.36

#   run nodenv-alias --auto

#   assert_success
#   assert_alias_version 0.8 0.8.10
#   assert_alias_version 0.10 0.10.23
#   assert_alias_version iojs-1.10 iojs-1.10.23
# }
