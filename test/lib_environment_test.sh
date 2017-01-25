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
    _assertHasManyLines "export should have 1 line" "${BUILD_DIR}/export" "1"

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

testExportVariables() {
    exportVariables "${BUILD_DIR}" "${ENV_DIR}"

    EXISTS=0
    [ -f "${BUILD_DIR}/export" ] && EXISTS=1
    assertEquals "export file should exists" "1" "$EXISTS"

    _assertHasManyLines "export should have 2 lines" "${BUILD_DIR}/export" "2"

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

_assertHasManyLines() {
    local message="$1"
    local filename="$2"
    local expected="$3"

    total_lines=$(wc -l "${filename}" | tr -s ' ' | sed -e 's/^ *//' | cut -f1 -d ' ')
    assertEquals "${message}" "${expected}" "${total_lines}"
}
