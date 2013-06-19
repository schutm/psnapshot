#!/bin/sh

# Test the helper functions
###########################

. ./test_helpers
. ../src/psnapshot

set +e  # Don't exit in case of errors, hey we're testing--expect some errors
set -u  # Treat unset variables as error in variable expansion
set +o errexit +o nounset
set +f

oneTimeSetUp() {
    testdir=$(mktemp -d)
    cmd_ssh       ""
    cmd_ssh_args  ""
    backup_server ""
}

oneTimeTearDown() {
    rm -rf "$testdir"
}

test_command_copy() {(
    echo "copy" > "$testdir/existing"

    assertTrue "Copy existing file" \
	"$(copy "$testdir/existing" "$testdir/existing.dest")"
    assertTrue "Source still exists" \
	"[ -e "$testdir/existing" ]"
    assertTrue "Target exist" \
	"[ -e "$testdir/existing.dest" ]"
    
    assertTrue "Copy non-existing file" \
	"$(remove "$testdir/nonexisting" "$testdir/nonexisting.dest")"
)}

test_command_makedir() {(
    assertTrue "Create a new directory" \
	"$(makedir "$testdir/newdir")"
    assertTrue "Directory is created" \
	"[ -d "$testdir/newdir" ]"

    assertTrue "Create an existing directory" \
	"$(makedir "$testdir/newdir")"
    assertTrue "Directory is still existant" \
	"[ -d "$testdir/newdir" ]"
)}

test_command_remove() {(
    echo "remove" > "$testdir/existing"
        
    assertTrue "Remove existing file" \
	"$(remove "$testdir/existing")"
    assertTrue "Remove non-existing file" \
	"$(remove "$testdir/nonexisting")"
)}

test_command_rename() {(
    echo "rename" > "$testdir/existing"

    assertTrue "Rename existing file" \
	"$(rename "$testdir/existing" "$testdir/existing.dest")"
    assertTrue "Source is removed" \
	"[ ! -e "$testdir/existing" ]"
    assertTrue "Target exist" \
	"[ -e "$testdir/existing.dest" ]"
    
    assertTrue "Rename non-existing file" \
	"$(remove "$testdir/nonexisting" "$testdir/nonexisting.dest")"
)}

test_command_setdate() {(
    echo "touch" > "$testdir/existing"

    assertTrue "Set date" \
	"$(setdate "$testdir/existing" "200001011111.11")"
    assertEquals "Timestamp set correctly" \
	"$(date -ur "$testdir/existing")" "Sat Jan  1 11:11:11 UTC 2000"
)}

test_command_ssh() {(
    startSkipping
    fail "No test for ssh at the moment"
    endSkipping
)}

test_command_synchronize() {(
    echo "sync" > "$testdir/existing"

    assertTrue "Synchronizing file" \
        "$(synchronize "$testdir/existing" "$testdir/dest")"
    assertTrue "Source still exist" \
        "[ -e "$testdir/existing" ]"
    assertTrue "Target exist" \
        "[ -e "$testdir/dest/$testdir/existing" ]"
)}

test_command_lexecute() {(
    assertEquals "Local execution of command with --force" \
        "test" "$(lexecute --force "echo test")"

    assertEquals "Local execution of command" \
        "test" "$(lexecute "echo test")"

    _test=$PSNAPSHOT_TRUE
    assertEquals "Local execution of command in test mode" \
        "" "$(lexecute "echo test")"
)}

test_command_rexecute() {(
    assertEquals "Remote execution of command with --force" \
        "test" "$(rexecute --force echo test)"

    assertEquals "Remote execution of command" \
        "test" "$(rexecute echo test)"

    _test=$PSNAPSHOT_TRUE
    assertEquals "Remote execution of command in test mode" \
        "" "$(rexecute echo test)"
)}