#!/bin/bash

# Made script more KISS for personal use.
# ~kotoko
#
# Original version from sakaki is available here:
#   https://github.com/sakaki-/genup/
#   https://github.com/sakaki-/sakaki-tools/tree/master/app-portage/genup
#

# Update portage tree and eix, then bring all packages in @world up-to-date.
# Clean up at the end, ensuring changes to files in /etc are processed.
# Will offer to update the kernel, if a new version has become available.
# Intended to be run interactively.
#
# Copyright (c) 2014-2020 sakaki <sakaki@deciban.com>
# Copyright (c) 2021 Jakub Romanowski (kotoko)
#
# License (GPL v3.0)
# ------------------
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

set -e
set -u
shopt -s nullglob

# Scroll to the bottom of this script to follow the main program flow.

# ********************** variables *********************
PROGNAME="$(basename "${0}")"
VERSION="1.0.28-kotoko"
ETCPROFILE="/etc/profile"
#UPDATERSDIR="/etc/${PROGNAME}/updaters.d"
UPDATERSDIR="/etc/genup/updaters.d"
RED_TEXT="" GREEN_TEXT="" YELLOW_TEXT="" RESET_ATTS="" ALERT_TEXT=""
if [[ -v TERM && -n "${TERM}" && "${TERM}" != "dumb" ]]; then
    RED_TEXT="$(tput setaf 1)$(tput bold)"
    GREEN_TEXT="$(tput setaf 2)$(tput bold)"
    YELLOW_TEXT="$(tput setaf 3)$(tput bold)"
    RESET_ATTS="$(tput sgr0)"
    ALERT_TEXT="$(tput bel)"
fi
declare -i VERBOSITY=1
PREFIXSTRING="* "
SHOWPREFIX="${GREEN_TEXT}${PREFIXSTRING}${RESET_ATTS}"
SHOWSUFFIX=""
VERBOSITYFLAG=""
ASKFLAG=""
ALERTFLAG=""
EMERGE=""
EMERGEARGS=""
EIXSYNCARGS=""
PORTAGEINFO=""
PORTAGEFEATURES=""
declare -i NEEDSDISPATCHCONF=0
# program arguments (booleans in this case)
declare -i ARG_ASK=0 ARG_HELP=0
declare -i ARG_VERBOSE=0 ARG_VERSION=0 ARG_DISPATCHCONF=0
declare -i ARG_NO_EIX_SYNC=0 ARG_ALERT=0
declare -i ARG_IGNORE_REQUIRED_CHANGES=0 ARG_NO_CUSTOM_UPDATERS=0
declare -i ARG_NO_EIX_METADATA_UPDATE=0
declare -i ADJUSTMENT=19
# force TERM if none found (e.g. when running from cron)
# otherwise mach builds (firefox etc.) will fail
if ! tty -s; then
    export TERM="dumb"
fi
# store copy of original args, and canonical path to genup itself
ORIGINAL_ARGS="${@}"
SCRIPTPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

# ***************** various functions ******************
cleanup_and_exit_with_code() {
    # add any cleanup code here
    trap - EXIT
    exit $1
}
show() {
    local MESSAGE=${1:-""}
    local VERBLEVEL=${2:-${VERBOSITY}}
    if (( VERBLEVEL >=1 )); then
        echo -e "${SHOWPREFIX}${MESSAGE}${SHOWSUFFIX}"
    fi
}
alertshow() {
    local MESSAGE=${1:-""}
    local VERBLEVEL=${2:-${VERBOSITY}}
    if ((ARG_ALERT==0)); then
        show "${@}"
    elif (( VERBLEVEL >=1 )); then
        echo -e "${SHOWPREFIX}${MESSAGE}${SHOWSUFFIX}${ALERT_TEXT}"
    fi
}
warning() {
    echo -e "${YELLOW_TEXT}${PREFIXSTRING}${RESET_ATTS}${PROGNAME}: Warning: ${1}" >&2
}
die() {
    echo
    echo -e "${RED_TEXT}${PREFIXSTRING}${RESET_ATTS}${PROGNAME}: Error: ${1} - exiting" >&2
    cleanup_and_exit_with_code 1
}
trap_cleanup() {
    trap - SIGHUP SIGQUIT SIGINT SIGTERM SIGKILL EXIT
    die "Caught signal"
}
trap trap_cleanup SIGHUP SIGQUIT SIGINT SIGTERM SIGKILL EXIT
test_yn() {
    echo -n -e "${SHOWPREFIX}${1} (y/n)? ${SHOWSUFFIX}${ALERT_TEXT}"
    read -r -n 1
    echo
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}
continue_yn() {
    if ! test_yn "${1}"; then
        echo -e "${RED_TEXT}${PREFIXSTRING}${RESET_ATTS}Quitting" >&2
        cleanup_and_exit_with_code 1
    fi
}
suppress_colours() {
    RED_TEXT=""
    GREEN_TEXT=""
    YELLOW_TEXT=""
    RESET_ATTS=""
    SHOWPREFIX="${PREFIXSTRING}"
}
suppress_alert() {
    ALERT_TEXT=""
}
suppress_colour_and_alert_if_output_not_to_a_terminal() {
    if [ ! -t 1 -o ! -t 2 ]; then
        # we are going to a non-terminal
        suppress_colours
        suppress_alert
    fi
}
set_idle_io_priority() {
    # prevent our operations stalling swap
    ionice -c 3 -p $$
}
read_portage_info_if_necessary() {
    if [ -z "${PORTAGEINFO}" ]; then
        show "Checking Portage configuration, please wait..."
        PORTAGEINFO="$(emerge --info)"
    fi
}
check_gcc_config_and_reset_if_necessary() {
    # check if gcc-config exists with an error - if it does, then
    # attempt to set one based on the current gcc version number
    # see https://wiki.gentoo.org/wiki/Upgrading_GCC
    if ! gcc-config --get-current-profile >/dev/null 2>&1; then
        # unset or invalid, attempt to force this to the current gcc
        # version
        read_portage_info_if_necessary
        local CHOST="$(grep '^CHOST=.*' <<<"${PORTAGEINFO}")"
        CHOST="$(cut -d\" -f2 <<< ${CHOST})"
        local GCC_VERSION="$(eix --installed --exact sys-devel/gcc --format '<installedversions:NAMEVERSION>' --versionsort | tail -n 1)"
        GCC_VERSION="${GCC_VERSION##*gcc-}"
        local FULL_GCC_ID="${CHOST}-${GCC_VERSION}"
        if gcc-config "${FULL_GCC_ID}"; then
            warning "gcc configuration was reset"
            env-update
            if [ -s "${ETCPROFILE}" ]; then
                set +e
                set +u
                source "${ETCPROFILE}"
                set -e
                set -u
            fi
            ${EMERGE} ${VERBOSITYFLAG} --oneshot sys-devel/libtool

            local BOOST_INSTALLED="$(eix --installed --exact dev-libs/boost --format '<installedversions:NAMEVERSION>' --versionsort | tr '\n' ' ')"
            for B in ${BOOST_INSTALLED}; do
                ${EMERGE} ${VERBOSITYFLAG} --oneshot "=${B}"
            done
        else
            die "failed to set gcc configuration"
        fi
    fi
}
display_greeting() {
    show "Gentoo System Updater v${VERSION}"
}
update_portage_tree_and_sync_eix() {
    if ((ARG_NO_EIX_SYNC==0)); then
        show "Updating Portage tree and syncing the eix cache"
        show "(this may take some time)..."
        # no longer explicitly set -q
        # (user can still do so via --eix-sync-args)
        eix-sync ${EIXSYNCARGS}
    else
        warning "As requested, not performing eix-sync"
    fi
}
remove_any_prior_emerge_resume_history() {
    # as if we call emerge --resume later, we don't want any hangovers from the
    # previous invocation
    show "Removing any prior emerge history..."
    emaint --fix cleanresume
}
ensure_portage_itself_is_up_to_date() {
    show "Bringing Portage itself up to date..."
    # don't fail on this, as an @world update may solve any blocks
    ${EMERGE} ${VERBOSITYFLAG} --oneshot --update sys-apps/portage || \
        warning "Could not update Portage: proceeding anyway"
}

update_all_packages_in_world_set_and_dependencies() {
    # performs deep dependency tree update, including build-time dependencies
    # will update any package whose use flags have changed
    # the @world set includes the @system set
    # will not re-emerge packages that are already up-to-date
    declare -i RC USER_CHANGES_REQUIRED=0
    show "Updating @world set (for new versions, or changed use flags)..."
    if ((ARG_ASK==0 && ARG_IGNORE_REQUIRED_CHANGES==0)); then
        # if in non-interactive mode, we'll check first if the build
        # looks possible; you can set the --ignore-required-changes option to
        # suppress this test
        if grep -qi "The following \(keyword\|mask\|USE\|license\) changes are necessary to proceed" \
            <(${EMERGE} ${VERBOSITYFLAG} ${EMERGEARGS} --pretend --deep \
            --with-bdeps=y --changed-use --update --backtrack=50 @world 2>&1 || true); then
            # silently note this fact, then fail later
            USER_CHANGES_REQUIRED=1
        fi
    fi
    if ! ${EMERGE} ${ASKFLAG} ${ALERTFLAG} ${VERBOSITYFLAG} ${EMERGEARGS} --deep \
        --with-bdeps=y --changed-use --update --backtrack=50 @world; then
        # per make manpage, if multiple "j" opts are specified, the last
        # one takes precedence, so this is legitimate
        if MAKEOPTS="${MAKEOPTS-} -j1" ${EMERGE} --resume; then
            warning "emerge completed successfully, but only by restricting"
            warning "build parallelism"
        else
            # we still have a problem, allow the user to attempt to fix if
            # running interactively
            if ((ARG_ASK==1)); then
                warning "emerge did not complete successfully"
                show "You can try to fix the problem in another console, then return here"
                show "and resume the emerge"
                continue_yn "Attempt to resume the emerge now"
                MAKEOPTS="${MAKEOPTS-} -j1" ${EMERGE} --resume
            else
                die "Failed to complete the emerge due to error"
            fi
        fi
    fi
    # this may have looked like it went OK, but still failed, because user
    # changes to e.g. /etc/portage/package.use are required (the resume
    # list will be empty in this case, so the retry with parallelism
    # off will 'succeed'): if this happens we'll bail out (unless explicitly
    # requested not to, via the --ignore-required-changes option)
    if ((USER_CHANGES_REQUIRED==1)); then
        die "Could not update @world because config changes required (please see above)"
    fi
}
rebuild_external_modules_if_necessary() {
    show "Creating any necessary external modules (e.g., VirtualBox)..."
    # exclude packages ending in '-bin'... by convention, these are binary
    # packages which means they aren't going to rebuild anything
    # (and may even be binary kernel packages, swept up into the
    # @module-rebuild set as they 'own' kernel modules in
    # /lib/modules/<release>/...)
    if ! ${EMERGE} ${VERBOSITYFLAG} @module-rebuild --exclude '*-bin'; then
        if MAKEOPTS="${MAKEOPTS-} -j1" ${EMERGE} --resume; then
            warning "emerge @module-rebuild completed successfully, but only by restricting"
            warning "build parallelism"
        else
            warning "Failed to complete emerge @module-rebuild due to error"
            warning "Continuing..."
        fi
    fi
}
rebuild_packages_depending_on_stale_libraries() {
    # when a shared library gets updated, and its soname is changed
    # all its consumers are not automatically rebuilt; assuming (the default)
    # that the preserve-libs feature is set, Portage will keep the old
    # library around (so that the application depending on it will keep working)
    # the below emerge will rebuild any such consumers, so that the old
    # library may be freed
    show "Rebuilding any consumers of old shared libraries, which did not autoupdate..."
    # do this twice - first, with getbinpkg enabled (as this'll pick up anything
    # already rebuilt on the binhost, if one is used, saving time) and then again with it
    # disabled, in case there are any local packages which need rebuilding (and
    # where we need to suppress getbinpkg, otherwise it'll just re-install from the
    # local tbz2)
    if ! ${EMERGE} ${VERBOSITYFLAG} @preserved-rebuild; then
        if MAKEOPTS="${MAKEOPTS-} -j1" ${EMERGE} --resume; then
            warning "emerge @preserved-rebuild completed successfully, but only by restricting"
            warning "build parallelism"
        else
            warning "Failed to complete emerge @preserved-rebuild due to error"
        fi
    fi
    show "Rebuilding again, with getbinpkg suppressed, to catch any local-only packages..."
    if ! FEATURES="-getbinpkg" ${EMERGE} ${VERBOSITYFLAG} @preserved-rebuild; then
        if MAKEOPTS="${MAKEOPTS-} -j1" FEATURES="-getbinpkg" ${EMERGE} --resume; then
            warning "emerge @preserved-rebuild completed successfully, but only by restricting"
            warning "build parallelism"
        else
            die "Failed to complete emerge @preserved-rebuild due to error"
        fi
    fi
}
bring_old_perl_modules_up_to_date() {
    # perl modules are built for a particular perl target, but are *not*
    # automatically rebuilt when perl upgrades to a higher version - the
    # below script fixes this
    show "Ensuring perl modules are matched to current version of perl..."
    perl-cleaner ${VERBOSITYFLAG} --all
}
cleanup_python_config() {
    # remove uninstalled versions from /etc/python-exec/python-exec.conf
    eselect python cleanup
}
run_custom_updaters_if_present() {
    # if not inhibited, find any executable files in the /etc/genup/updaters.d
    # top-level directory (resolving symlinks) and execute them in turn,
    # failing if any returns a non-zero exit code
    local NEXTPATH
    local REALPATH
    if ((ARG_NO_CUSTOM_UPDATERS==0)); then
        if [ -d "${UPDATERSDIR}" ]; then
            for NEXTPATH in "${UPDATERSDIR}"/*; do
                REALPATH="$(readlink --canonicalize "${NEXTPATH}")"
                if [[ -f "${REALPATH}" && -s "${REALPATH}" && -x "${REALPATH}" ]]; then
                    show "Running custom updater '${NEXTPATH}'..."
                    if ! "${REALPATH}"; then
                        die "Error running custom updater '${NEXTPATH}'"
                    fi
                fi
            done
        fi
    fi
}
check_if_dispatch_conf_needs_to_be_run() {
    # check if the user has any configuration file changes pending review
    # by dispatch-conf, and set the NEEDSDISPATCHCONF variable accordingly
    # we do a rough check to see if there are any pending changes
    local DIRS_TO_CHECK="$(emerge --info | grep '^CONFIG_PROTECT=' | cut -d"\"" -f2)"
    local PENDING_CHANGES="$(find ${DIRS_TO_CHECK} -name '*._cfg*' -type f -print)"
    if [ -n "${PENDING_CHANGES}" ]; then
        NEEDSDISPATCHCONF=1
    else
        NEEDSDISPATCHCONF=0
    fi
}
interactively_resolve_clashing_config_file_changes() {
    # where user has changed an e.g. /etc/ file overwritten by a package
    # update, invoke an interactive tool allowing them to resolve the issue
    # only available in interactive mode...
    check_if_dispatch_conf_needs_to_be_run
    if ((NEEDSDISPATCHCONF==1)); then
        if ((ARG_ASK==1 || ARG_DISPATCHCONF==1)); then
            alertshow "Handing any updated configuration file clashes..."
            dispatch-conf
            NEEDSDISPATCHCONF=2 # special flag; we'll recheck later
        fi
        # otherwise, user will be warned at end to run dispatch-conf
    else
        show "No configuration files need updating"
    fi
}
update_environment() {
    # append values in /etc/env.d/... files into /etc/profile.env
    # also create /etc/ld.so.conf, and run ldconfig (to recreate
    # /etc/ld.so.cache)
    env-update
}
update_eix_metadata() {
    # ensure eix metadata is up-to-date (will not be if
    # only non-gentoo repos have changed in this run)
    # following does not hit the network
    show "Updating eix metadata..."
    eix-sync -0 |& sed -e '/^Processing/d'
}
remove_unreferenced_packages() {
    # following should be reasonably safe, it removes any packages that are not
    # required by the transitive closure of @world set dependencies
    show "Removing packages not required by @world set..."
    ${EMERGE} ${ASKFLAG} ${ALERTFLAG} ${VERBOSITYFLAG} --depclean
    # we may have just blown away our old version of gcc, but not enabled
    # the replacement version's config, so...
    check_gcc_config_and_reset_if_necessary
}
rebuild_where_missing_libraries_detected() {
    # check for missing shared library dependencies (possibly caused by
    # emerge --depclean) and attempt to fix them, by re-emerging the broken
    # libraries and binaries (shouldn't do much nowadays, but good to check!)
    show "Fixing any broken/missing libraries and binaries caused by cleanup..."
    revdep-rebuild
}
display_final_status() {
    show
    if ((NEEDSDISPATCHCONF==2)); then
        # double-check that the user resolved everything earlier
        check_if_dispatch_conf_needs_to_be_run
    fi
    if ((NEEDSDISPATCHCONF==1)); then
        warning "There are configuration file changes pending review!"
        warning "Please run dispatch-conf to interactively resolve them."
    else
        show "There are no configuration file changes pending review."
    fi
    show "You may now wish to issue:"
    show "  source /etc/profile"
    show "to ensure your current shell environment is fully up-to-date."
    show "Subsequent login shells will automatically pick up any changes."
    show
    show "All done - your system is now up-to-date!"
}
print_usage() {
    cat << EOF
Usage: ${PROGNAME} [options]

Options:
  -a, --ask             turns on interactive mode: you must confirm key actions
  -A, --alert           sound terminal bell when interaction required
                        (selecting this also automatically selects --ask)
  -c, --dispatch-conf   run dispatch-conf, even if in non-interactive mode
  -C, --no-custom-updaters
                        do not run any custom updaters from the
                        ${UPDATERSDIR}
  -e, --emerge-args=ARGS
                        pass provided additional ARGS to the main emerge
                        e.g., use --emerge-args='--autounmask-write' to
                        automatically make necessary changes to config files
  -h, --help            show help message and exit
  -i, --ignore-required-changes
                        don't exit with an error in the event that user-driven
                        changes are required (to /etc/portage/package.use etc.)
                        in order to complete the @world update step
  -r, --adjustment=N    set niceness (-20<=N<=19) of the build process
                        (the default is ${ADJUSTMENT}; 19=background; -20=foreground)
  -S, --no-sync         do not attempt to run eix-sync
  -v, --verbose         ask called programs to display more information
  -V, --version         display the version number of ${PROGNAME} and exit
  -x, --eix-sync-args=ARGS
                        pass provided additional ARGS to eix-sync
                        (e.g. use --eix-sync-args="-q" to suppress output)
EOF
}
print_help() {
    cat << EOF
${PROGNAME} - update Portage tree and all installed packages
EOF
    print_usage
}
print_version() {
    printf "%s\n" "${VERSION}"
}
display_usage_message_and_bail_out() {
    if [ ! -z "${1+x}" ]; then
        printf "%s: %s\n" "${PROGNAME}" "${1}" >&2
    fi
    print_usage >&2
    cleanup_and_exit_with_code 1
}
internal_consistency_option_checks() {
    # following not exhaustive, just some more obvious snafus
    if ((ADJUSTMENT<-20 || ADJUSTMENT>19)); then
            display_usage_message_and_bail_out "must have -20 <= build niceness adjustment <= 19"
    fi
}
read_portage_features_if_necessary() {
    read_portage_info_if_necessary
    if [ -z "${PORTAGEFEATURES}" ]; then
        PORTAGEFEATURES="$(grep '^FEATURES.*$' <<<"${PORTAGEINFO}")"
    fi
}
process_command_line_options() {
    local TEMP
    declare -i RC
    set +e
        # error trapping off, as we want to handle errors
        TEMP="$(getopt -o aAcCe:hir:SvVx: --long ask,alert,dispatch-conf,no-custom-updaters,emerge-args:,help,ignore-required-changes,adjustment:,no-sync,verbose,version,eix-sync-args: -n "${PROGNAME}" -- "${@}")"
        RC="${?}"
    set -e
    if ((RC!=0)); then
        display_usage_message_and_bail_out
    fi
    eval set -- "${TEMP}"

    # extract options and their arguments into variables.
    while true ; do
        case "${1}" in
            -a|--ask) ARG_ASK=1 ; shift ;;
            -A|--alert) ARG_ALERT=1 ; ARG_ASK=1 ; shift ;;
            -c|--dispatch-conf) ARG_DISPATCHCONF=1 ; shift ;;
            -C|--no-custom-updaters) ARG_NO_CUSTOM_UPDATERS=1 ; shift ;;
            -e|--emerge-args)
                case "${2}" in
                    "") shift 2 ;;
                    *) EMERGEARGS="${2}" ; shift 2 ;;
                esac ;;
            -h|--help) ARG_HELP=1 ; shift ;;
            -i|--ignore-required-changes) ARG_IGNORE_REQUIRED_CHANGES=1 ; shift ;;
            -r|--adjustment)
                case "${2}" in
                    "") shift 2 ;;
                    *) ADJUSTMENT="${2}" ; shift 2 ;;
                esac ;;
            -S|--no-sync) ARG_NO_EIX_SYNC=1 ; shift ;;
            -v|--verbose) ARG_VERBOSE=1 ; shift ;;
            -V|--version) ARG_VERSION=1 ; shift ;;
            -x|--eix-sync-args)
                case "${2}" in
                    "") shift 2 ;;
                    *) EIXSYNCARGS="${2}" ; shift 2 ;;
                esac ;;
            --) shift ; break ;;
            *) die "Internal error!" ;;
        esac
    done
    # process 'perform-then-exit' options
    if ((ARG_HELP==1)); then
        print_help
        cleanup_and_exit_with_code 0
    elif ((ARG_VERSION==1)); then
        print_version
        cleanup_and_exit_with_code 0
    fi

    # setup emerge command with specified niceness
    EMERGE="nice -n ${ADJUSTMENT} emerge"

    # set verbosity
    if ((ARG_VERBOSE==1)); then
        VERBOSITY+=1
    fi
    if ((VERBOSITY>1)); then
        VERBOSITYFLAG="--verbose"
    fi
    # set interactive mode
    if ((ARG_ASK==1)); then
        ASKFLAG="--ask"
    fi
    if ((ARG_ALERT==1)); then
        ALERTFLAG="--alert"
    else
        suppress_alert
    fi
    internal_consistency_option_checks
}

# *************** start of script proper ***************
suppress_colour_and_alert_if_output_not_to_a_terminal
set_idle_io_priority
process_command_line_options "${@}"
display_greeting
check_gcc_config_and_reset_if_necessary
update_portage_tree_and_sync_eix
remove_any_prior_emerge_resume_history
ensure_portage_itself_is_up_to_date
update_all_packages_in_world_set_and_dependencies
remove_unreferenced_packages
rebuild_external_modules_if_necessary
rebuild_packages_depending_on_stale_libraries
bring_old_perl_modules_up_to_date
cleanup_python_config
interactively_resolve_clashing_config_file_changes
remove_unreferenced_packages
rebuild_where_missing_libraries_detected
rebuild_packages_depending_on_stale_libraries
purge_old_distfiles_if_desired
update_environment
update_eix_metadata
run_custom_updaters_if_present
display_final_status
cleanup_and_exit_with_code 0
# **************** end of script proper ****************
