#!/bin/bash

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/all.sh"


afterSetUp() {
    # Create the control file
    cat > "${BUILD_DIR}/${ENV_BUILDPACK_CONTROL_FILE}" <<EOT
RANDOM_VARIABLE
OTHER_VARIABLE
EOT

    # Populate variables
    echo "value-a" > "${ENV_DIR}/RANDOM_VARIABLE"
    echo "value-b" > "${ENV_DIR}/OTHER_VARIABLE"
}

testExportVariableShouldExportOneVariable() {
    exportVariable "${BUILD_DIR}" "${ENV_DIR}" "RANDOM_VARIABLE"
    assertTrue "[ ${RETURN} -eq 0 ]"

    EXISTS=0
    [ -f "${BUILD_DIR}/export" ] && EXISTS=1
    assertEquals "export file should exist" "1" "$EXISTS"

    # Has only one line
    total_lines=$(wc -l "${BUILD_DIR}/export" | tr -s ' ' | cut -f2 -d ' ')
    assertEquals "1" "$total_lines"

    # Has export line
    grep 'export RANDOM_VARIABLE=value-a' "${BUILD_DIR}/export" > /dev/null
    assertEquals "$?" "0"
}

testExportVariableShouldNotExportVariableWhenVariableDoesntExist() {
    exportVariable "${BUILD_DIR}" "${ENV_DIR}" "UNKNOWN_VARIABLE"

    assertEquals "wrong return value" "1" "$RETURN"

    EXISTS=0
    [ -f "${BUILD_DIR}/export" ] && EXISTS=1
    assertEquals "export file should not exists" "0" "$EXISTS"
}

SKIP_testGetVariablesToExport() {
    vars=$(exportVariables "${BUILDPACK_HOME}/test/fixtures/env_dir" "$BUILD_DIR")
    assertEquals "RANDOM_VARIABLE" "${vars}"
}

SKIP_testGetVariablesToExportWhenControlFileDoesntExist() {
    rm -f "${BUILD_DIR}/${ENV_BUILDPACK_CONTROL_FILE}"
    vars=$(getVariablesToExport "${BUILDPACK_HOME}/test/fixtures/env_dir" "$BUILD_DIR")
    assertEquals "" "${vars}"
}

testExportVariables() {
    exportVariables "${BUILD_DIR}" "${ENV_DIR}"

    EXISTS=0
    [ -f "${BUILD_DIR}/export" ] && EXISTS=1
    assertEquals "export file should exists" "1" "$EXISTS"

    total_lines=$(wc -l "${BUILD_DIR}/export" | tr -s ' ' | cut -f2 -d ' ')
    assertEquals "export file should have 2 lines" "2" "$total_lines"

    grep 'export RANDOM_VARIABLE=value-a' "${BUILD_DIR}/export" > /dev/null
    assertEquals "export file should have export line for RANDOM_VARIABLE" "$?" "0"

    grep 'export OTHER_VARIABLE=value-b' "${BUILD_DIR}/export" > /dev/null
    assertEquals "export file should have export line for OTHER_VARIABLE" "$?" "0"
}

testExportVariablesShouldNotCreateExportFileWhenControlFileDoesntExist() {
    rm -f "${BUILD_DIR}/${ENV_BUILDPACK_CONTROL_FILE}"
    exportVariables "${BUILD_DIR}" "${ENV_DIR}"

    EXISTS=0
    [ -f "${BUILD_DIR}/export" ] && EXISTS=1
    assertEquals "export file should not exists" "0" "$EXISTS"
}
