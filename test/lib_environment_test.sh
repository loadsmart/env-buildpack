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

    assertTrue "export file should exists" "[ -f ${BUILD_DIR}/export ]"
    assertTrue "grep 'export RANDOM_VARIABLE=value-a' ${BUILD_DIR}/export > /dev/null"
    assertTrue "grep 'export OTHER_VARIABLE=value-b' ${BUILD_DIR}/export > /dev/null"
}
