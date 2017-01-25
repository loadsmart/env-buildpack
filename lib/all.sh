#!/bin/sh
#
# Make sure we always include the files in the same order
#

# shellcheck source=lib/config.sh
. "${BUILDPACK_HOME}/lib/config.sh"

# shellcheck source=lib/environment.sh
. "${BUILDPACK_HOME}/lib/environment.sh"
# shellcheck source=lib/output.sh
. "${BUILDPACK_HOME}/lib/output.sh"
