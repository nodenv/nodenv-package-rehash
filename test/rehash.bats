#!/usr/bin/env bats

load test_helper

libexec=${BATS_TEST_DIRNAME}/../libexec

fake_env_for_npm() {
  export npm_lifecycle_event=post$1
  export npm_package_name=$2
  export npm_package_version=${3-latest}

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

  run $libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook handles package with @org scope" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install @org/testdouble

  run $libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook handles package with @org scope and version/dist-tag" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install @org/testdouble latest

  run $libexec/nodenv-rehash

  assert_success
  unstub nodenv
}

@test "npm hook still rehashes and exits cleanly when missing vars" {
  stub nodenv 'rehash : true'
  unset npm_package_name npm_package_version npm_config_argv

  run $libexec/nodenv-rehash

  assert_success
  assert_output "nodenv-package-rehash: can't determine target package"
  unstub nodenv
}

@test "npm hook exits cleanly even if nodenv-rehash errors" {
  stub nodenv 'rehash : false'
  fake_env_for_npm install teenytest

  run $libexec/nodenv-rehash

  assert_success
  assert_output "nodenv-package-rehash: error rehashing; manual \`nodenv rehash' likely needed"
  unstub nodenv
}

@test "npm hook warns if installing a buggy npm" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install npm 5.10.0

  run $libexec/nodenv-rehash

  assert_success
  assert_line "WARNING: Automatic rehashing provided by nodenv-package-rehash will not work"
  unstub nodenv
}

@test "npm hook only warns if package is npm" {
  stub nodenv 'rehash : true'
  fake_env_for_npm install yarn 5.10.0

  run $libexec/nodenv-rehash

  assert_success
  refute_line -p "WARNING: Automatic rehashing"
  unstub nodenv
}
