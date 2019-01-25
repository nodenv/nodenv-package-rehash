#!/usr/bin/env bats

load test_helper

libexec=${BATS_TEST_DIRNAME}/../libexec

fake_env_for_npm() {
  export npm_lifecycle_event=post$1
  export npm_package_name=${2%@*}
  export npm_package_version=${2#*@}
  export npm_config_argv='{"remain":["'$2'"],"cooked":["i","--global","'$2'"],"original":["i","-g","'$2'"]}'
}

@test "npm hook rehashes for the 'main' package" {
  stub nodenv 'rehash : echo rehashing'
  fake_env_for_npm install lineman

  run $libexec/nodenv-rehash

  assert_success
  assert_output "rehashing"
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
