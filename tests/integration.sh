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
    
    cmd_ssh             "eval"
    cmd_ssh_args        ""
    cmd_cp_verbose_arg  ""
    cmd_mkdir_verbose_arg  ""
    cmd_mv_verbose_arg  ""
    cmd_rm_verbose_arg  ""

    backup_server ""

    loglevel        0
    snapshot_root   $testdir/tgt

    retain retain0   3
    retain retain1   2

    backup $testdir/src        tgt
}

initDir() {
    [ -e $1 ] || mkdir -p $1

    touch $1/$2
}

setUp() {
    initDir $testdir/src            src.orig
    initDir $testdir/tgt/retain0.0  file0.0
    initDir $testdir/tgt/retain0.1  file0.1
    initDir $testdir/tgt/retain0.2  file0.2
    initDir $testdir/tgt/retain1.0  file1.0
    initDir $testdir/tgt/retain1.1  file1.1
}

tearDown() {
    rm -rf $testdir/src
    rm -rf $testdir/tgt/retain0.0
    rm -rf $testdir/tgt/retain0.1
    rm -rf $testdir/tgt/retain0.2
    rm -rf $testdir/tgt/retain1.0
    rm -rf $testdir/tgt/retain1.1
}

oneTimeTearDown() {
    rm -rf $testdir
}

test_rotate() {(
    rotate 0

    assertTrue "First retention became second retention" \
	"[ -e "$testdir/tgt/retain0.1" ] && [ -e "$testdir/tgt/retain0.1/file0.0" ]"
    assertFalse "First retention is unavailable" \
	"[ -e "$testdir/tgt/retain0.0" ]"
)}

test_propagate() {(
    # Create space for the propagation
    rm -rf $testdir/tgt/retain1.0

    propagate 1
    assertFalse "First retention is unavailable" \
        "[ -e "$testdir/tgt/retain0.2" ]" 
    assertTrue "First retention is propegated to the second retention" \
        "[ -e "$testdir/tgt/retain1.0/file0.2" ]" 
)}

test_snapshot() {(
    # Create space for the snapshot
    rm -rf $testdir/tgt/retain0.0

    snapshot 0 "200001011111.11"
    assertTrue "Snapshot of source is created" \
        "[ -e "$testdir/tgt/retain0.0/tgt/$testdir/src/src.orig" ]"     
)}

test_archive() {(
    eval "snapshot()  { echo 'snapshot';  }"
    eval "propagate() { echo 'propagate'; }"

    assertEquals "Snapshot created for first retention" \
	"snapshot" "$(archive 0)"
    assertEquals "Propagation performed for second retention" \
	"propagate" "$(archive 1)"
)}

test_log() {(
    for _verbosity in 0 1 2 3 4; do
        i=0
        for fn in error info message verbose debug; do
            assertEquals "Function '$fn' with verbosity level of '$_verbosity'" \
	        "$([ $_loglevel -lt $i ] || echo 'Log')" "$(echo $($fn 'Log' 2>&1))"
        i=$((i+1))
	done
    done
)}