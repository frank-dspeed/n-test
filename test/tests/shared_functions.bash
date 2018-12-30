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


# display_remote_version <version>
# Limited support for using index.tab to resolve version into a number.
# Return version number, including leading v.

function display_remote_version() {
  # ToDo: support NODE_MIRROR

  local fetch
  if command -v curl &> /dev/null; then
    fetch="curl --silent --location --fail"
  else
    # insecure to match current n implementation
    fetch="wget -q -O- --no-check-certificate"
  fi

  local match='xxx'
  if [[ "$1" = "lts" ]]; then
    match='[^-]$'
  elif [[ "$1" = "latest" ]]; then
    match='.'
  fi

  # Using temporary variable as curl complains if pipe closes early (e.g. head).
  # (Not filtering for platform yet.)
  local versions
  versions="$(${fetch} "https://nodejs.org/dist/index.tab" | tail -n +2 | grep -E "${match}" | cut -f -1)"
  echo "${versions}" | head -n 1
}
