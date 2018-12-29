#!/usr/bin/env bats

load shared_functions


function setup() {
  unset_n_env
  setup_tmp_prefix
  install_dummy_node
}


function teardown() {
  rm -rf "${TMP_PREFIX_DIR}"
}


# Explicit version
@test "install: 4.9.1" {
  n "4.9.1"
  run node --version
  [ "${output}" = "v4.9.1" ]
}


# Explicit version, optional leading v
@test "install: v4.9.1" {
  n "v4.9.1"
  run node --version
  [ "${output}" = "v4.9.1" ]
}


# Partial version
@test "install: 4" {
  n "4"
  run node --version
  [ "${output}" = "v4.9.1" ]
}


# Partial version, optional leading v
@test "install: v4" {
  n "v4"
  run node --version
  [ "${output}" = "v4.9.1" ]
}


# Partial version
@test "install: 4.9" {
  n "4.9"
  run node --version
  [ "${output}" = "v4.9.1" ]
}
