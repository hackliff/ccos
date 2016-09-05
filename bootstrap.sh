#! /usr/bin/env bash
#
# Copyright (C) 2016 hackliff <xavier.bruhiere@gmail.com>
#
# This script serves as a convenient bootstraper for our use case but these
# instructions should probably be set manually (or this file is a serious
# threat critiacl point in your defensive policy).

readonly DEFAULT_APP_NAME="example"

give_up() {
  echo "error: $@"
  return
}

prepare_auth() {
  local policy_name="${1-${DEFAULT_APP_NAME}}"

  vault policy-write ${policy_name} ./policies/app-${policy_name}.hcl
  vault token-create -policy="${policy_name}"
  echo "WARNING: export this info!"
}

write_config() {
  # apps' configurations are exepected to live as a nested object at
  # `secret/apps/{{ app_name }}/config`
  local app_name="${1-${DEFAULT_APP_NAME}}"

  vault write secret/apps/${app_name}/config \
    host=localhost \
    port=3000

  vault write secret/apps/global/keys \
    ${app_name}_key="qwerty"
}

main() {
  [ -n "${VAULT_TOKEN}" ] || give_up "please export VAULT_TOKEN"
  [ -n "${VAULT_ADDR}" ] || give_up "please export VAULT_TOKEN"

  prepare_auth $@
  write_config $@
}

main $@
