#!/usr/bin/env bash
# unset the n environment variables so tests running from known state

unset N_PREFIX

# Undocumented [sic]
unset NODE_MIRROR

# Documented under "custom source", but PROJECT and HTTP implemented as independent
unset PROJECT_NAME
unset PROJECT_URL
unset PROJECT_VERSION_CHECK
unset HTTP_USER
unset HTTP_PASSWORD
