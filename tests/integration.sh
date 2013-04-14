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
    loglevel        0
    backup_server   localhost
    snapshot_root   /root

    retain hourly   6
    retain daily    7
    retain weekly   4
    retain monthly  6

    backup /etc/        /
    backup /home/       /   extra,args
}

test_retain() {(
    assertEquals "Index of 'quaterly' retention" \
        -1 "$(retention_index quaterly)"
    assertEquals "Index of 'weekly' retention" \
        2 "$(retention_index weekly)"

    assertEquals "History of retention '4' (not specified)" \
        -1 "$(retention_history 4)"
    assertEquals "History of retention '2' (weekly)" \
        4 "$(retention_history 2)"
	
    assertEquals "Retention identifier of retention '4' (not specified)" \
        "" "$(retention 4)"
    assertEquals "Retention identifier of retention '2' (weekly)" \
        "weekly" "$(retention 2)"
)}

test_rotate() {(
    eval "rremove() { assertEquals 'Remove last backup' '/root/weekly.3' \"\$1\"; }"
    eval "cnt=$(($(retention_history 2)-1));                                              \
          rrename() {                                                                      \
              assertEquals 'Rename last backup to'   \"/root/weekly.\$((cnt--))\" \"\$2\"; \
              assertEquals 'Rename last backup from' \"/root/weekly.\$((cnt))\"   \"\$1\"; \
	  }"
    rotate 2
)}

test_propagate() {(
    eval "rrename() {                                                             \
              assertEquals 'Rename last backup to'   \"/root/weekly.0\"  \"\$2\"; \
              assertEquals 'Rename last backup from' \"/root/daily.6\"   \"\$1\"; \
	  }"
    propagate 2
)}

test_snapshot() {(
    eval "rcopy() {                                                            \
              assertEquals 'Target file name'   \"/root/hourly.0\"  \"\$2\";                   \
              assertEquals 'Original file name' \"/root/hourly.1\"   \"\$1\";                  \
	  }"
    eval "rmkdir() {                                                             \
              assertEquals 'Remove file name'   \"/root/hourly.0\"  \"\$1\";                   \
	  }"
    eval "rtouch() {                                                             \
              assertEquals 'Touching file name'   \"/root/hourly.0\"  \"\$1\"; \
              assertEquals 'Touching to date' \"20130228140538.30\"   \"\$2\"; \
	  }"
    eval "src='/etc/'; tgt='localhost:/root/hourly.0/'; opt='';                            \
           synch() {                                                             \
              assertEquals 'Synching from source'   \"\$src\"   \"\$1\"; \
              assertEquals 'Synching to target'     \"\$tgt\"   \"\$2\"; \
              assertEquals 'Synching options'       \"\$opt\"   \"\$3\"; \
	      src='/home/'; tgt='localhost:/root/hourly.0/'; opt='extra,args';
	  }"

    snapshot 0 "20130228140538.30"
)}

test_archive() {(
    eval "propagate() {                                                             \
              assertEquals 'Propagate'   4  \$1; \
	  }"
    eval "snapshot() {                                                             \
              assertEquals 'Snapshot'   0   \$1; \
	  }"

    archive 0
    archive 4
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