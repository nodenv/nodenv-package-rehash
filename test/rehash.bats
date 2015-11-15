#!/usr/bin/env bats

load test_helper

@test "matching package triggers rehash" {
  stub nodenv 'rehash : echo "rehashing"'
  export npm_package_name=lineman
  export npm_config_argv='{"remain":["lineman"],"cooked":["i","--global","lineman"],"original":["i","-g","lineman"]}'

  run ./libexec/nodenv-rehash

  assert_success
  assert_output "rehashing"
  unstub nodenv
}

@test "non-matching package does not trigger rehash" {
  stub nodenv 'rehash : false'
  export npm_package_name=grunt
  export npm_config_argv='{"remain":["lineman"],"cooked":["i","--global","lineman"],"original":["i","-g","lineman"]}'

  run ./libexec/nodenv-rehash

  assert_success
  assert_output ""
}
