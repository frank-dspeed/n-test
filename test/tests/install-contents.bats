#!/usr/bin/env bats

load unset-n-env

# Test that files get installed to expected locations
# https://github.com/tj/n/issues/246

@test "install: contents" {
  readonly TARGET_VERSION="4.9.1"
  readonly TMP_PREFIX="$(mktemp -d)"

  [ ! -d "${TMP_PREFIX}/n/versions" ]
  [ ! -d "${TMP_PREFIX}/bin" ]
  [ ! -d "${TMP_PREFIX}/include" ]
  [ ! -d "${TMP_PREFIX}/lib" ]
  [ ! -f "${TMP_PREFIX}/shared" ]

  N_PREFIX="${TMP_PREFIX}" n ${TARGET_VERSION}

  # Cached version
  [ -d "${TMP_PREFIX}/n/versions/node/${TARGET_VERSION}" ]
  # Installed into each of key folders
  [ -f "${TMP_PREFIX}/bin/node" ]
  [ -f "${TMP_PREFIX}/bin/npm" ]
  [ -d "${TMP_PREFIX}/include/node" ]
  [ -d "${TMP_PREFIX}/lib/node_modules" ]
  [ -d "${TMP_PREFIX}/share/doc/node" ]

"${TMP_PREFIX}/bin/node" --version
  run "${TMP_PREFIX}/bin/node" --version
  [ "${output}" = "v${TARGET_VERSION}" ]

  rm -rf "${TMP_PREFIX}"
}
