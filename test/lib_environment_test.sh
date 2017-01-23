#!/bin/bash

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/environment.sh"
# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/output.sh"


test_populate_variables_to_export() {
    vars=$(getVariablesToExport "${BUILDPACK_HOME}/test/fixtures/env_dir")
    assertEquals ":RANDOM_VARIABLE" "${vars}"
}

test_populate_variables_to_export_when_control_var_doesnt_exists() {
    vars=$(getVariablesToExport "${BUILDPACK_HOME}/test/fixtures/wrong_env_dir")
    assertEquals "" "${vars}"
}

test_export_variables() {
    local buildpack_dir env_dir
    buildpack_dir=$(mktemp -d)
    env_dir=$(mktemp -d)
    echo "value-a" > "$env_dir/variable-a"
    echo "value-b" > "$env_dir/variable-b"

    expected="$(cat <<EOF
export variable-a=value-a
export variable-b=value-b
EOF
)"

    exportVariables "$buildpack_dir" "$env_dir" "variable-a:variable-b"
    assertTrue "export file not created" "[ -f $buildpack_dir/export ]"
    assertEquals "$expected" "$(cat "$buildpack_dir/export")"
}
