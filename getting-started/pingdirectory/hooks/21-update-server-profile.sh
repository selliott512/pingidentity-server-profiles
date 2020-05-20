#!/usr/bin/env sh
#
# Ping Identity DevOps - Docker Build Hooks
#
# TODO A lot needs to be done here
# TODO 1. Rather than a git pull, we might need to do a git clone/branch/tag based on server profile.
# TODO    i.e. what if it chagnes
# TODO
# TODO 2. expansion of templates?
# TODO
# TODO For PingData products, a lot of this will change with native server-profiles
#
${VERBOSE} && set -x

# shellcheck source=pingcommon.lib.sh
. "${HOOKS_DIR}/pingcommon.lib.sh"

if test "${SERVER_PROFILE_UPDATE}" = "true" ; then
    #
    # Remote updates
    #
    set -x
    cd "${SERVER_PROFILE_DIR}" || exit 97
    git pull
    # shellcheck disable=SC2035
    cp -af . "${STAGING_DIR}"
    # shellcheck disable=SC2164
    cd -

    #
    # Local updates
    #
    # shellcheck disable=SC2086
    apply_local_server_profile
fi

if test -n "${MAX_HEAP_SIZE}" ; then
    # Set the new max heap size.
    # TODO: Also allow the turning parameter to be specified via a variable?
    dsjavaproperties --initialize --jvmTuningParameter AGGRESSIVE --maxHeapSize "${MAX_HEAP_SIZE}"
fi
