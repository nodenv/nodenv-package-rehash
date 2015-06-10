#!/usr/bin/env bats

load test_helper

setup() {
  # two nodes installed (0.10, 0.12)
  create_versions 0.10 0.12
  stub nodenv-versions \
    "--bare : echo 0.10 0.12"
  stub nodenv-prefix \
    "'' : echo $NODENV_ROOT/versions/0.10" \
    "0.10 : echo $NODENV_ROOT/versions/0.10" \
    "0.12 : echo $NODENV_ROOT/versions/0.12"

  # 0.10 is active,
  stub nodenv-version-name "echo 0.10"

  # only 0.12 has hooks
  mkdir -p $NODENV_ROOT/versions/0.12/lib/node_modules/.hooks
  touch $NODENV_ROOT/versions/0.12/lib/node_modules/.hooks/postinstall
  touch $NODENV_ROOT/versions/0.12/lib/node_modules/.hooks/postuninstall
}

# teardown() {
#   # unstub nodenv-prefix
#   # unstub nodenv-versions
# }

@test "nodenv-package-hooks list" {
  run nodenv-package-hooks list

  assert_success
  assert_output <<-OUTPUT
		0.10
		no hooks installed
	OUTPUT
}

@test "nodenv-package-hooks list --all" {
  run nodenv-package-hooks list --all

  assert_success
  assert_output <<-OUTPUT
		0.10
		no hooks installed
		0.12
		postinstall
		postuninstall
	OUTPUT
}

@test "nodenv-package-hooks list 0.12" {
  run nodenv-package-hooks list 0.12

  assert_success
  assert_output <<-OUTPUT
		0.12
		postinstall
		postuninstall
	OUTPUT
}

@test "nodenv-package-hooks install" {
skip
  run nodenv-package-hooks install

  assert_success
  assert_package_hooks 0.10
  # refute_package_hooks 0.12
}

@test "nodenv-package-hooks install <version>" {
skip
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
