#!/bin/sh

# Test the helper functions
###########################

. ./test_helpers
. ../src/psnapshot

set +e  # Don't exit in case of errors, hey we're testing--expect some errors
set -u  # Treat unset variables as error in variable expansion
set +o errexit +o nounset
set +f

test_bail() {(
    assertEquals "Expect custom message" \
        "bailed" "$(bail "bailed" 2>&1)"

    assertFalse "Expect exit code of $PSNAPSHOT_BAIL" \
        "bail"
)}

test_in_list() {(
    assertBail in_list 0

    assertTrue "Find needle in list" \
        "in_list 1 4 3 2 1"
    assertFalse "Find needle in list of 0 elements" \
        "in_list 1"
    assertFalse "Find non-existing needle in list" \
        "in_list 1 4 3 2"
)}

test_create_scalar_dsl() {(
    assertBail create_scalar_dsl 1
    assertBail create_scalar_dsl 3

    create_scalar_dsl dsl_scalar_test "default"
    assertBail dsl_scalar_test 0
    assertBail dsl_scalar_test 2
    assertSet dsl_scalar_test
)}

test_create_cmd_dsl() {(
    assertBail create_cmd_dsl 1
    assertBail create_cmd_dsl 5

    create_cmd_dsl dsl_test arg2 arg3 arg4
    assertSet cmd_dsl_test
    assertSet cmd_dsl_test_args
    assertSet cmd_dsl_test_verbose_arg
)}

test_create_array_dsl() {(
    assertBail create_array_dsl 1

    create_array_dsl dsl_array_test 1 2 4
    assertBail dsl_array_test 0
    assertBail dsl_array_test 3
    assertBail dsl_array_test 5

    dsl_array_test arg1
    dsl_array_test 'arg 1' 'arg 2'
    dsl_array_test 'arg 1' 'arg 2' arg/3 "arg'4'"
    assertEquals "Array format" \
        "arg1 '' '' '' 'arg 1' 'arg 2' '' '' 'arg 1' 'arg 2' arg/3 arg\'4\'" "${_dsl_array_test}"
)}
