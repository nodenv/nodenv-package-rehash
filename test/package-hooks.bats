#!/usr/bin/env bats

load test_helper

setup() {
  # four nodes installed
  create_versions 0.8 0.10 0.11 0.12

  # two nodes already have hooks
  stub_hooks_for 0.11
  stub_hooks_for 0.12

  refute_package_hooks 0.8
  refute_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "list installed hooks for active node (default)" {
  NODENV_VERSION=0.10 run nodenv package-hooks list

  assert_success
  assert_output - <<-OUTPUT
		0.10
		no hooks installed
	OUTPUT
}

@test "lists installed hooks for specified node" {
  run nodenv package-hooks list 0.12

  assert_success
  assert_output - <<-OUTPUT
		0.12
		postinstall
		postuninstall
	OUTPUT
}

@test "list installed hooks for all nodes" {
  run nodenv package-hooks list --all

  assert_success
  assert_output - <<-OUTPUT
		0.10
		no hooks installed
		0.11
		postinstall
		postuninstall
		0.12
		postinstall
		postuninstall
		0.8
		no hooks installed
	OUTPUT
}

@test "install hooks for active node (default)" {
  NODENV_VERSION=0.10 run nodenv package-hooks install

  assert_success
  refute_package_hooks 0.8
  assert_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "install hooks for specified node" {
  run nodenv package-hooks install 0.8

  assert_success
  assert_package_hooks 0.8
  refute_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "install hooks for all nodes" {
  run nodenv package-hooks install --all

  assert_success
  assert_package_hooks 0.8
  assert_package_hooks 0.10
  assert_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "uninstall hooks from active node (default)" {
  NODENV_VERSION=0.11 run nodenv package-hooks uninstall

  assert_success
  refute_package_hooks 0.8
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "uninstall hooks from specified node" {
  run nodenv package-hooks uninstall 0.11

  assert_success
  refute_package_hooks 0.8
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  assert_package_hooks 0.12
}

@test "uninstall hooks from all nodes" {
  run nodenv package-hooks uninstall --all

  assert_success
  refute_package_hooks 0.8
  refute_package_hooks 0.10
  refute_package_hooks 0.11
  refute_package_hooks 0.12
}
