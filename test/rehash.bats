#!/usr/bin/env bats

load test_helper

libexec=${BATS_TEST_DIRNAME}/../libexec

fake_env_for_npm() {
  export npm_lifecycle_event=post$1
  export npm_package_name=$2
  export npm_package_version=$3

  local p=$2${3+@$3}
  export npm_config_argv='{"remain":["'$p'"],"cooked":["i","--global","'$p'"],"original":["i","-g","'$p'"]}'
}

@test "npm hook rehashes for the 'main' package" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install lineman

  run $libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook doesn't rehash for dependencies" {
  stub nodenv 'rehash : echo rehashing'
  fake_env_for_npm install lineman
  npm_package_name=grunt

  run $libexec/nodenv-rehash

  assert_success
  refute_output
}

@test "npm hook handles installs specifying version or dist-tag" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install testdouble latest

  run ./libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook handles package with @org scope" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install @org/testdouble

  run ./libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook handles package with @org scope and version/dist-tag" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install @org/testdouble latest

  run ./libexec/nodenv-rehash

  assert_success
  unstub nodenv
}
