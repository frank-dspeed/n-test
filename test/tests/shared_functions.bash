#!/usr/bin/env bash


# unset the n environment variables so tests running from known state.
# Globals:
#   lots

function unset_n_env(){
  unset N_PREFIX

  # Undocumented [sic]
  unset NODE_MIRROR

  # Documented under "custom source", but PROJECT and HTTP implemented as independent
  unset PROJECT_NAME
  unset PROJECT_URL
  unset PROJECT_VERSION_CHECK
  unset HTTP_USER
  unset HTTP_PASSWORD
}


# Create a dummy version of node so `n install` will always activate (and not be affected by possible system version of node).

function install_dummy_node() {
  local prefix="${N_PREFIX-/usr/local}"
  mkdir -p "${prefix}/bin"
  echo "echo vDummy" > "${prefix}/bin/node"
  chmod a+x "${prefix}/bin/node"
}


# Create temporary dir and configure n to use it.
# Globals:
#   TMP_PREFIX_DIR
#   N_PREFIX
#   PATH

function setup_tmp_prefix() {
  TMP_PREFIX_DIR="$(mktemp -d)"
  [ -d "${TMP_PREFIX_DIR}" ] || exit 2
  # return a safer variable to `rm -rf` later than N_PREFIX
  export TMP_PREFIX_DIR

  export N_PREFIX="${TMP_PREFIX_DIR}"
  export PATH="${N_PREFIX}/bin:${PATH}"
}
