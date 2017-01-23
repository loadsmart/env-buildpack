#!/bin/sh

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/environment.sh"
# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/output.sh"


test_info_should_add_7_spaces_at_beginning_of_string()
{
    capture info sample string
    assertCapturedEquals "       sample string"
}
