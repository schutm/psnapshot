#!/bin/sh

# Test the Domain Specific Language (DSL) for psnapshot
#######################################################

. ./test_helpers
. ../src/psnapshot

set +e  # Don't exit in case of errors, hey we're testing--expect some errors
set -u  # Treat unset variables as error in variable expansion
set +o errexit +o nounset
set +f

test_cmd_dsl() {(
    for cmd in cp date mv rm mkdir rsync touch ssh; do
        for arg in '' args verbose_arg; do
            assertSet "cmd_${cmd}${arg:+_}${arg}"
        done
    done

    assertSet "cmd_rsync_test_arg"
)}

test_scalar_dsl() {(
    for cmd in backup_server snapshot_root loglevel; do
        assertSet "${cmd}"
    done
)}

test_array_dsl() {(
    for cmd in include exclude; do
        eval "$cmd \"arg'1\""
        eval "$cmd arg/2"

        assertEquals "_$cmd is set" \
	    "arg\'1 arg/2 " "$(eval "printf '%s ' "\${_$cmd}"")"
    done

    retain hourly 6
    retain daily  7
    assertEquals "_retain is set" \
        "hourly 6 daily 7 " "$(eval "printf '%s ' "\${_retain}"")"

    backup /src1 /tgt1
    backup /src2 /tgt2 options
    assertEquals "_backup is set" \
        "/src1 /tgt1 '' /src2 /tgt2 options " "$(eval "printf '%s ' "\${_backup}"")"
)}
