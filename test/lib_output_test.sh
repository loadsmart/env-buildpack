#!/bin/sh

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/environment.sh"
# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/output.sh"


testInfoShouldAdd7SpacesAtBeginningOfString()
{
    capture info sample string
    assertCapturedEquals "       sample string"
}
