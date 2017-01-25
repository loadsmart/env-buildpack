# shellcheck disable=SC2034
# Config variables

# File containing the variables to be exported in the compile phase.
# The format is one variable name per line, uppercase,
# without any leading or trailing spaces
# Eg.:
#
# MY_RANDOM_VAR
# ANOTHER_RANDOM_VAR
#

ENV_BUILDPACK_CONTROL_FILE=".env-export"
