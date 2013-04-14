#!/bin/sh

# Test the helper functions
###########################

. ./test_helpers
. ../src/psnapshot

set +e  # Don't exit in case of errors, hey we're testing--expect some errors
set -u  # Treat unset variables as error in variable expansion
set +o errexit +o nounset
set +f

test_parse_args() {(
    assertFalse "Arguments 'a' in -ca not recognized" \
        "parse_args -ca"
    assertFalse "Argument -c needs additional argument option" \
        "parse_args -c"
    assertFalse "-- stops argument parsing" \
        "parse_args -c --"

    assertEquals "Variable '_configfile' before argument parsing" \
        "/etc/psnapshot.conf" "${_configfile}"
    assertEquals "Variable '_help' before argument parsing" \
        $PSNAPSHOT_FALSE "${_help}"
    assertEquals "Variable '_test' before argument parsing" \
        $PSNAPSHOT_FALSE "${_test}"
    assertEquals "Variable '_verbose' before argument parsing" \
        0 "${_verbose}"
    assertEquals "Variable '_version' before argument parsing" \
        $PSNAPSHOT_FALSE "${_version}"
    assertEquals "Variable '_command' before argument parsing" \
        "" "${_command}"

    parse_args -htvvvV -c -config.conf -- -command
    
    assertEquals "Variable '_configfile' after argument parsing" \
        "-config.conf" "${_configfile}"
    assertEquals "Variable '_help' after argument parsing" \
        $PSNAPSHOT_TRUE "${_help}"
    assertEquals "Variable '_test' after argument parsing" \
        $PSNAPSHOT_TRUE "${_test}"
    assertEquals "Variable '_verbose' after argument parsing" \
        3 "${_verbose}"
    assertEquals "Variable '_version' after argument parsing" \
        $PSNAPSHOT_TRUE "${_version}"
    assertEquals "Variable '_command' after argument parsing" \
        "-command" "${_command}"
)}
