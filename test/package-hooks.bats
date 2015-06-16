#!/usr/bin/env bats

load test_helper

stub_hooks_for() {
  version="$1"
  mkdir -p $NODENV_ROOT/versions/$version/lib/node_modules/.hooks
  touch $NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postinstall
  touch $NODENV_ROOT/versions/$version/lib/node_modules/.hooks/postuninstall
}

setup() {
  # two nodes installed (0.10, 0.12)
  create_versions 0.10 0.12
  stub nodenv-versions \
    "--bare : echo 0.10 0.11 0.12"
  stub nodenv-prefix \
    "echo $NODENV_ROOT/versions/0.10" \
    "0.10 : echo $NODENV_ROOT/versions/0.10" \
    "0.11 : echo $NODENV_ROOT/versions/0.11" \
    "0.12 : echo $NODENV_ROOT/versions/0.12"

  # 0.10 is active,
  stub nodenv-version-name "echo 0.10"

  # only 0.12 has hooks
  stub_hooks_for 0.12
}

@test "nodenv-package-hooks list" {
  run nodenv-package-hooks list

  assert_success
  assert_output <<-OUTPUT
		0.10
		no hooks installed
	OUTPUT
}

@test "nodenv-package-hooks list <version>" {
  run nodenv-package-hooks list 0.12

  assert_success
  assert_output <<-OUTPUT
		0.12
		postinstall
		postuninstall
	OUTPUT
}

@test "nodenv-package-hooks list --all" {
  run nodenv-package-hooks list --all

  assert_success
  assert_output <<-OUTPUT
		0.10
		no hooks installed
		0.11
		no hooks installed
		0.12
		postinstall
		postuninstall
	OUTPUT
}

@test "nodenv-package-hooks install" {
  run nodenv-package-hooks install

  assert_success
  assert_package_hooks 0.10
  refute_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "nodenv-package-hooks install <version>" {
  run nodenv-package-hooks install 0.11

  assert_success
  refute_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "nodenv-package-hooks install --all" {
  run nodenv-package-hooks install --all

  assert_success
  assert_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "nodenv-package-hooks uninstall" {
  stub_hooks_for 0.10
  assert_package_hooks 0.10

  run nodenv-package-hooks uninstall

  assert_success
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "nodenv-package-hooks uninstall <version>" {
  stub_hooks_for 0.11
  assert_package_hooks 0.11

  run nodenv-package-hooks uninstall 0.11

  assert_success
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "nodenv-package-hooks uninstall --all" {
  stub_hooks_for 0.11
  assert_package_hooks 0.11
  assert_package_hooks 0.12

  run nodenv-package-hooks uninstall --all

  assert_success
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  refute_package_hooks 0.12
}
