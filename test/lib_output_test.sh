#!/bin/sh

# shellcheck source=/dev/null
. "${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh"

# shellcheck source=/dev/null
. "${BUILDPACK_HOME}/lib/all.sh"


testInfoShouldAdd7SpacesAtBeginningOfString()
{
    capture info sample string
    assertCapturedEquals "       sample string"
}
