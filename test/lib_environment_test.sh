#!/bin/bash

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/all.sh"


afterSetUp() {
    # Create the control file
    cat > "${BUILD_DIR}/${ENV_BUILDPACK_CONTROL_FILE}" <<EOT
RANDOM_VARIABLE
EOT
}

testGetVariablesToExport() {
    vars=$(getVariablesToExport "${BUILDPACK_HOME}/test/fixtures/env_dir" "$BUILD_DIR")
    assertEquals ":RANDOM_VARIABLE" "${vars}"
}

testGetVariablesToExportWhenControlFileDoesntExist() {
    rm -f "${BUILD_DIR}/${ENV_BUILDPACK_CONTROL_FILE}"
    vars=$(getVariablesToExport "${BUILDPACK_HOME}/test/fixtures/env_dir" "$BUILD_DIR")
    assertEquals "" "${vars}"
}

testExportVariables() {
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
    assertTrue "export file should exists" "[ -f $buildpack_dir/export ]"
    assertEquals "$expected" "$(cat "$buildpack_dir/export")"
}
