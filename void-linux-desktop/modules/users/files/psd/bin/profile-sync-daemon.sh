#!/bin/bash

#
# Profile-sync-daemon by graysky <graysky AT archlinux DOT us>
# Inspired by some code originally written by Colin Verot
#

# needed for debian 8.x
[[ -h /sbin ]] || PATH=$PATH:/sbin

BLD="\e[01m"
RED="\e[01;31m"
GRN="\e[01;32m"
BLU="\e[01;34m"
NRM="\e[00m"
VERS="6.35"

user=$(id -un)
HOME="$(getent passwd "$user" | cut -d: -f6)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PSDCONFDIR="$XDG_CONFIG_HOME/psd"
PSDCONF="$PSDCONFDIR/psd.conf"
SHAREDIR="/usr/share/psd"
XDG_RUNTIME_DIR="/tmp/$user"
VOLATILE="$XDG_RUNTIME_DIR"
PID_FILE="$VOLATILE/psd.pid"
SHAREDIR="$HOME/.bin/psd"

mkdir -p "$XDG_RUNTIME_DIR"

if [[ ! -d "$SHAREDIR" ]]; then
  echo -e " ${RED}ERROR:${NRM}${BLD} Missing ${BLU}$SHAREDIR${NRM}${BLD} - reinstall the package to use profile-sync-daemon.${NRM}"
  exit 1
fi

if [[ ! -d "$SHAREDIR/browsers" ]]; then
  echo -e " ${RED}ERROR:${NRM}${BLD} Missing ${BLU}$SHAREDIR/browsers${NRM}${BLD} - reinstall the package to use profile-sync-daemon.${NRM}"
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  echo -e " ${RED}WARNING:${NRM}${BLD} Do not call ${BLU}$0${NRM}${BLD} as root.${NRM}"
  exit 1
fi

if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
  echo -e " ${RED}ERROR:${NRM}${BLD} Cannot find XDG_RUNTIME_DIR which should be set by systemd.${NRM}"
  exit 1
fi

# Setup check for config file
if [[ -f "$PSDCONF" ]]; then
  if [[ ! -f "$PID_FILE" ]]; then
    # do nothing if psd is currently running, otherwise
    # make sure only comments and variables/arrays are defined to prevent
    # problems like issue #166
    if egrep -q -v '^$|^#|^[^ ]*=[^;]*' "$PSDCONF"; then
      # something that isn't a blank line, comment, or variable present
      # so exit
      echo -e " ${RED}ERROR:${NRM}${BLD} Syntax error(s) detected in ${BLU}$PSDCONF${NRM}${BLD} - edit and try again.${NRM}"
      echo -e "${NRM}${BLD}Line number: offending comment${NRM}"
      egrep -vn '^$|^#|^[^ ]*=[^;]*' "$PSDCONF"
      exit 1
    fi
  fi
  . "$PSDCONF"
elif [[ -d "$HOME/.psd" ]]; then
  # first check to see if a legacy ~/.psd is present and then move it to the
  # new location
  mkdir -p "$PSDCONFDIR"
  rsync -ax "$HOME/.psd/" "$PSDCONFDIR/"
  rm -rf "$HOME/.psd"
  echo " The use of $HOME/.psd is deprecated. Existing config has been moved to $PSDCONFDIR"
  # source it again retaining any user options
  [[ -f "$PSDCONF" ]] && . "$PSDCONF"
else
  mkdir -p "$PSDCONFDIR"
  if [[ -f "$SHAREDIR/psd.conf" ]]; then
    cp "$SHAREDIR/psd.conf" "$PSDCONFDIR"
    echo -e " First time running psd so please edit ${BLU}$PSDCONF${NRM}${BLD} to your liking and run again.${NRM}"
    exit 0
  fi
fi

# if psd is active, source the snapshot of psd.conf preferentially
# version 6.03 renames this file so if older version is running then
# rotate the old name to the new one

[[ -f "$PSDCONFDIR/.$user@$(hostname).pid.conf" ]] &&
  mv "$PSDCONFDIR/.$user@$(hostname).pid.conf" "$PSDCONFDIR/.psd.conf"

if [[ -f "$PID_FILE" ]]; then
  if [[ -f "$PSDCONFDIR/.psd.conf" ]]; then
    PSDCONF="$PSDCONFDIR/.psd.conf"
    unset USE_OVERLAYFS BROWSERS USE_BACKUPS
    . "$PSDCONF"
    # defining VOLATILE in the config is deprecated since v6.16
    VOLATILE="$XDG_RUNTIME_DIR"
  fi
fi

# define default number of crash-recovery snapshots to save if the user did not
# and check that it is an integer if user did define it
if [[ -z "$BACKUP_LIMIT" ]]; then
  BACKUP_LIMIT=5
else
  if [[ "$BACKUP_LIMIT" =~ ^[0-9]+$ ]]; then
    # correctly setup
    true
  else
    echo -e " ${RED}ERROR:${NRM}${BLD} Bad value for BACKUP_LIMIT detected!${NRM}"
    exit 1
  fi
fi

# BROWSERS defined as string var so redefine it as an array
if [[ -z "$BROWSERS" ]]; then
  BROWSERS=( $(find "$SHAREDIR/browsers" -type f -printf "%f\n") )
else
  BROWSERS=( $BROWSERS )
fi

# simple function to determine user intent rather than using a null value
case "${USE_OVERLAYFS,,}" in
  y|yes|true|t|on|1|enabled|enable|use)
    OLFS=1
    ;;
  *)
    OLFS=0
    ;;
esac

# since the default for this one is a yes, need to force a null value to yes
[[ -z "${USE_BACKUPS,,}" ]] && USE_BACKUPS="yes"

case "${USE_BACKUPS,,}" in
  y|yes|true|t|on|1|enabled|enable|use)
    CRRE=1
    ;;
  *)
    CRRE=0
    ;;
esac

# determine is we are using overlayfs (v22 and below) or overlay (v23 and above)
# since mount should call modprobe on invocation, check to see if either
# module is in the tree using modinfo

if [[ $OLFS -eq 1 ]]; then
  # first check to see if either is hardcoded into the kernel
  # and of course prefer version 23
  [[ $(grep -ciE "overlayfs$" /proc/filesystems) -eq 1 ]] && OLFSVER=22
  [[ $(grep -ciE "overlay$" /proc/filesystems) -eq 1 ]] && OLFSVER=23
fi

if [[ -z $OLFSVER ]]; then
  # if neither is hardcoded, see if either module is available
  modinfo overlayfs &>/dev/null
  [[ $? -eq 0 ]] && OLFSVER=22

  modinfo overlay &>/dev/null
  [[ $? -eq 0 ]] && OLFSVER=23
fi

# get distro name
# first try os-release
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ -n "$PRETTY_NAME" ]]; then
    distro="$PRETTY_NAME"
  elif [[ -n "$NAME" ]]; then
    distro="$NAME"
  fi
else
  # if not os-release try issue
  if [[ -n $(sed 's| \\.*$||' /etc/issue | head -n 1) ]]; then
    distro="$(sed 's| \\.*$||' /etc/issue | head -n 1)"
  else
    # fuck it
    distro=
  fi
fi

header() {
  [[ -z "$distro" ]] && echo -e "${BLD}Profile-sync-daemon v$VERS${NRM}" ||
    echo -e "${BLD}Profile-sync-daemon v$VERS${NRM}${BLD} on $distro${NRM}"
  echo
}

dep_check() {
  # checks for dependencies and that psd.conf is setup correctly
  command -v rsync >/dev/null 2>&1 || {
  echo -e " ${BLD}I require rsync but it's not installed. ${RED}Aborting!${NRM}" >&2; exit 1; }
  command -v modinfo >/dev/null 2>&1 || {
  echo -e " ${BLD}I require modinfo but it's not installed. ${RED}Aborting!${NRM}" >&2; exit 1; }
  command -v awk >/dev/null 2>&1 || {
  echo -e " ${BLD}I require awk but it's not installed. ${RED}Aborting!${NRM}" >&2; exit 1; }
  if [[ $OLFS -eq 1 ]]; then
    [[ $OLFSVER -ge 22 ]] || {
    echo -e " ${BLD}Your kernel requires either the ${BLU}overlay${NRM}${BLD} or ${BLU}overlayfs${NRM}${BLD} module to use${NRM}"
    echo -e " ${BLD}to use psd's in overlay mode. Cannot find either in your kernel so compile it in and${NRM}"
    echo -e " ${BLD}try again or remove the option from ${BLU}$PSDCONF${NRM}${BLD}. ${RED}Aborting!${NRM}" >&2; exit 1;}
  fi

  if [[ -f /etc/psd.conf ]]; then
    echo -e "${BLD} This version of psd does not support /etc/psd.conf since it runs as your user.${NRM}"
    echo -e "${BLD} Recommend that you remove /etc/psd.conf and run it in systemd's user mode:${NRM}"
    echo -e "${BLD}   systemd --user <action> psd.service${NRM}"
    exit 1
  fi
}

config_check() {
  if [[ $OLFS -eq 1 ]]; then
    # user must have sudo rights to call /usr/bin/mount
    # and /usr/bin/umount to use overlay mode

    sudo -kn psd-overlay-helper &>/dev/null
    [[ $? -ne 0 ]] && FAILCODE=1

    if [[ $FAILCODE -ne 0 ]]; then
      echo -e "${BLD}${RED} ERROR!${NRM}${BLD} To use overlayfs mode, $user needs sudo access to ${BLU}/usr/bin/psd-overlay-helper${NRM}${BLD}${NRM}"
      echo
      echo -e " ${BLD}Add the following line to the end of ${BLU}/etc/sudoers${NRM}${BLD} to enable this functionality:${NRM}"
      echo -e "  ${BLD}$user ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper${NRM}"
      exit 1
    fi
  fi

  for browser in "${BROWSERS[@]}"; do
    if [[ ! -f "$SHAREDIR/browsers/$browser" ]]; then
      # user defined an invalid browser
      echo -e " ${BLD}${RED}$browser${NRM}${BLD} is not a supported browser. Check config file for typos: ${NRM}${BLU}$PSDCONF${NRM}"
      exit 1
    fi
  done
}

ungraceful_state_check() {
  # if the machine was ungracefully shutdown then the backup will be
  # on the filesystem and the link to tmpfs will be on the filesystem
  # but the contents will be empty we need to simply remove the link
  # and rotate the backup into place
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    for item in "${DIRArr[@]}"; do
      DIR="$item"
      BACKUP="$item-backup"
      BACK_OVFS="$item-back-ovfs"

      # all is well so continue
      [[ -e "$DIR/.flagged" ]] && continue

      NOW=$(date +%Y%m%d_%H%M%S)
      if [[ -h "$DIR" ]]; then
        # symlinked browser profiles are not supported so bail if one is detected
        if [[ -d $(readlink "$DIR") ]]; then
          echo -e " ${RED}Warning!${NRM}"
          echo -e " ${BLD}${BLU}$DIR${NRM}${BLD} appears to be a symlink but these are not supported.${NRM}"
          echo -e " ${BLD}Please make the browser profile a live directory and try again. Exiting.${NRM}"
          exit 1
        else
          echo "Ungraceful state detected for $DIR so fixing"
          unlink "$DIR"
        fi
      fi

      if [[ -d "$BACKUP" ]]; then
        if [[ -d "$BACK_OVFS" ]]; then
          # always snapshot the most recent of these two dirs...
          # if using overlayfs $BACK_OVFS and $BACKUP should be compared
          # against each other to see which is newer and then that should
          # be what psd snapshots since BACKUP (the lowerdir) is readonly
          # at the time the user started psd could be many resync cycles
          # in the past

          BACKUP_TIME=$(stat "$BACKUP" | grep Change | awk '{ print $2,$3 }')
          BACK_OVFS_TIME=$(stat "$BACK_OVFS" | grep Change | awk '{ print $2,$3 }')

          [[ $(date -d "$BACK_OVFS_TIME" "+%s") -ge $(date -d "$BACKUP_TIME" "+%s") ]] &&
            TARGETTOKEEP="$BACK_OVFS" ||
            TARGETTOKEEP="$BACKUP"

          if [[ $CRRE -eq 1 ]]; then
            opts="-a --reflink=auto"
            cp $opts "$TARGETTOKEEP" "$BACKUP-crashrecovery-$NOW"
          fi

          mv --no-target-directory "$TARGETTOKEEP" "$DIR"
          rm -rf "$BACKUP"
        else
          # we only find the BACKUP and no BACKOVFS then either the initial resync
          # never occurred before the crash using overlayfs or we aren't using overlayfs
          # at all which can be treated the same way

          if [[ $CRRE -eq 1 ]]; then
            opts="-a --reflink=auto"
            cp $opts "$BACKUP" "$BACKUP-crashrecovery-$NOW"
            mv --no-target-directory "$BACKUP" "$DIR"
          fi
        fi
      fi

      # if overlayfs was active but is no longer, remove $BACK_OVFS
      [[ $OLFS -eq 1 ]] || rm -rf "$BACK_OVFS"
    done
  done
}

cleanup() {
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    for item in "${DIRArr[@]}"; do
      DIR="$item"
      CRASHArr=( $(find "${DIR%/*}" -type d -name '*crashrecovery*'|sort -r) )
      if [[ ${#CRASHArr[@]} -gt 0 ]]; then
        echo -e "${BLD}Deleting ${#CRASHArr[@]} crashrecovery dir(s) for profile ${BLU}$DIR${NRM}"
        for backup in "${CRASHArr[@]}"; do
          echo -e "${BLD}${RED} $backup${NRM}"
          rm -rf "$backup"
        done
        unset CRASHArr
      else
        echo -e "${BLD}Found no crashrecovery dirs for: ${BLU}$DIR${NRM}${BLD}${NRM}"
      fi
      echo
    done
  done
}

load_env_for() {
  browser="$1"

  homedir=$HOME
  group=$(id -g "$user")

  ### Arrays
  # profileArr is transient used to store profile paths parsed from
  # firefox and aurora
  unset profileArr
  # DIRArr is a full path corrected for both relative and absolute paths
  # reset global variables and arrays
  unset DIRArr

  unset PSNAME
  . "$SHAREDIR/browsers/$browser"
}

running_check() {
  # check for browsers running and refuse to start if so
  # without this cannot guarantee profile integrity
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    [[ -z "$PSNAME" ]] && continue
    if pgrep -u "$user" "\<$PSNAME\>" &>/dev/null; then
      echo "Refusing to start; $browser is running by $user!"
      exit 1
    fi
  done
}

suffix_needed() {
  browser=$1
  unset check_suffix
  . "$SHAREDIR/browsers/$browser"
  [[ -n "$check_suffix" ]]
}

dup_check() {
  # only for firefox, icecat, seamonkey, palemoon, and aurora
  # the LAST directory in the profile MUST be unique
  # make sure there are no duplicates in ~/.mozilla/<browser>/profiles.ini
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    if suffix_needed "$browser"; then
      # nothing to check
      [[ -z "${DIRArr[@]}" ]] && continue
      # browser is on system so check profiles
      #
      # check that the LAST DIRECTORY in the full path is unique
      unique_count=$(echo "${DIRArr[@]##*/}" | sed 's/ /\n/g' | sort -u | wc -l)
      # no problems so do nothing
      [[ ${#DIRArr[@]} -eq $unique_count ]] && continue

      echo -e " ${RED}Error: ${NRM}${BLD}dup profile for ${GRN}$browser${NRM}${BLD} detected. See psd manpage, correct, and try again.${NRM}"
      # clip of the 'heftig-' to give correct path
      [[ "$browser" = "heftig-aurora" ]] && browser="${browser##*-}"
      profile_ini="$homedir/.mozilla/$browser/profiles.ini"
      [[ "$browser" = "palemoon" ]] &&
        profile_ini="$homedir/.moonchild productions/pale moon/profiles.ini"
      echo -e " ${BLD}Must have unique last directories in ${BLU}${profile_ini}${NRM}${BLD} to use psd.${NRM}"
      exit 1
    fi
  done
}

kill_browsers() {
  # check for browsers running and kill them to safely sync/unsync
  # without this cannot guarantee profile integrity
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"

    local x=1
    while [[ $x -le 60 ]]; do
      [[ -n "$PSNAME" ]] || break
      pgrep -u "$user" "\<$PSNAME\>" &>/dev/null || break

      if [[ $x -le 5 ]]; then
        pkill -SIGTERM -u "$user" "\<$PSNAME\>"
      else
        pkill -SIGKILL -u "$user" "\<$PSNAME\>"
      fi

      x=$(( x + 1 ))
      sleep .05
    done
  done
}

do_sync_for() {
  browser=$1
  load_env_for "$browser"
  for item in "${DIRArr[@]}"; do
    DIR="$item"
    BACKUP="$item-backup"
    BACK_OVFS="$item-back-ovfs"
    suffix=
    if suffix_needed "$browser"; then
      suffix="-${item##*/}"
    fi
    TMP="$VOLATILE/$user-$browser$suffix"
    UPPER="$VOLATILE/$user-$browser${suffix}-rw"
    WORK="$VOLATILE/.$user-$browser${suffix}"
    local REPORT

    # make tmpfs container
    if [[ -d "$DIR" ]]; then
      # retain permissions on sync target
      PREFIXP=$(stat -c %a "$DIR")
      [[ -r "$TMP" ]] || install -dm"$PREFIXP" --owner="$user" --group="$group" "$TMP"

      if [[ $OLFS -eq 1 ]]; then
        if [[ $OLFSVER -eq 23 ]]; then
          [[ -r "$UPPER" ]] || install -dm"$PREFIXP" --owner="$user" --group="$group" "$UPPER"
          [[ -r "$WORK" ]] || install -dm"$PREFIXP" --owner="$user" --group="$group" "$WORK"
        elif [[ $OLFSVER -eq 22 ]]; then
          [[ -r "$UPPER" ]] || install -dm"$PREFIXP" --owner="$user" --group="$group" "$UPPER"
        fi
      fi

      # backup target and link to tmpfs container
      if [[ $(readlink "$DIR") != "$TMP" ]]; then
        mv --no-target-directory "$DIR" "$BACKUP"
        # refuse to start browser while initial sync
        ln -s /dev/null "$DIR"
      fi

      # sync the tmpfs targets to the disc
      if [[ -e "$DIR"/.flagged ]]; then
        REPORT="resync"
        if [[ $OLFS -eq 1 ]]; then
          rsync -aX --delete-after --inplace --no-whole-file --exclude .flagged "$DIR/" "$BACK_OVFS/"
        else
          rsync -aX --delete-after --inplace --no-whole-file --exclude .flagged "$DIR/" "$BACKUP/"
        fi
      else
        # initial sync
        REPORT="sync"
        if [[ $OLFS -eq 1 ]]; then
          sudo psd-overlay-helper -v "$OLFSVER" -l "$BACKUP" -u "$UPPER" -w "$WORK" -d "$TMP" mountup
          if [[ $? -ne 0 ]]; then
            echo -e "Error in trying to mount $TMP - this should not happen!"
            exit 1
          fi
        else
          # keep user from launching browser while rsync is active
          rsync -aX --inplace --no-whole-file "$BACKUP/" "$TMP"
        fi

        # now browser can start
        [[ $(readlink "$DIR") = "/dev/null" ]] && unlink "$DIR"
        ln -s "$TMP" "$DIR"
        chown -h "$user":"$group" "$DIR"
        touch "$DIR/.flagged"
      fi
      echo -e "${BLD}$browser $REPORT successful${NRM}"
    else
      if [[ ! -d "$homedir" ]] ; then
        echo -e "${RED}$DIR does not exist! Is /home unmounted?${NRM}" >&2
        exit 1
      elif [[ -d "$BACKUP" ]] ; then
        echo -e "${RED}$DIR does not exist or is a broken symlink! Is $VOLATILE unmounted?${NRM}" >&2
        exit 1
      fi
    fi
  done
}


do_sync() {
  touch "$PID_FILE"

  # make a snapshot of psd.conf and redefine its location to this snapshot
  # while psd is running to keep any edits made to the "live" psd.conf from
  # potentially orphaning the snapshot copies thus preserving the data

  [[ -f "$PSDCONFDIR/.psd.conf" ]] || {
  echo "# Automatically generated file; DO NOT EDIT!" > "$PSDCONFDIR/.psd.conf"
  echo "# The purpose is to snapshot the settings used when psd was activated." >> "$PSDCONFDIR/.psd.conf"
  echo "# Any edits to the live config: $PSDCONFDIR/psd.conf" >> "$PSDCONFDIR/.psd.conf"
  echo "# will be applied the _next_ time psd is activated." >> "$PSDCONFDIR/.psd.conf"
  echo "#" >> "$PSDCONFDIR/.psd.conf"
  echo "USE_OVERLAYFS=\"$USE_OVERLAYFS\"" >> "$PSDCONFDIR/.psd.conf"
  echo "BROWSERS=\"${BROWSERS[*]}\"" >> "$PSDCONFDIR/.psd.conf"
  echo "USE_BACKUPS=\"$USE_BACKUPS\"" >> "$PSDCONFDIR/.psd.conf"
  chmod 400 "$PSDCONFDIR/.psd.conf"
}

local browser
for browser in "${BROWSERS[@]}"; do
  do_sync_for "$browser"
done
}

enforce() {
  local browser
  for browser in "${BROWSERS[@]}"; do
    CRASHArr=( $(find "${DIR%/*}" -type d -name '*crashrecovery*'|sort -r) )
    if [[ ${#CRASHArr[@]} -gt $BACKUP_LIMIT ]]; then
      for remove in "${CRASHArr[@]:$BACKUP_LIMIT}"; do
        rm -rf "$remove"
      done
    fi
    unset CRASHArr
  done
}

do_unsync() {
  rm -f "$PID_FILE" "$PSDCONFDIR/.psd.conf"

  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    for item in "${DIRArr[@]}"; do
      DIR="$item"
      BACKUP="$item-backup"
      BACK_OVFS="$item-back-ovfs"
      suffix=
      if suffix_needed "$browser"; then
        suffix="-${item##*/}"
      fi
      TMP="$VOLATILE/$user-$browser$suffix"
      UPPER="$VOLATILE/$user-$browser${suffix}-rw"
      WORK="$VOLATILE/.$user-$browser${suffix}"
      # check if user has browser profile
      if [[ -h "$DIR" ]]; then
        unlink "$DIR"
        # this assumes that the backup is always updated so
        # be sure to invoke a sync before an unsync
        #
        # restore original dirtree
        [[ -d "$BACKUP" ]] && mv --no-target-directory "$BACKUP" "$DIR"
        if [[ $OLFS -eq 1 ]] && mountpoint -q "$TMP"; then
          rsync -aX --delete-after --inplace --no-whole-file --exclude .flagged "$BACK_OVFS/" "$DIR/"
          sudo psd-overlay-helper -d "$TMP" mountdown &&
            rm -rf "$TMP" "$UPPER" "$WORK"
        fi
        [[ -d "$TMP" ]] && rm -rf "$TMP"
        echo -e "${BLD}$browser unsync successful${NRM}"
      else
        if [[ ! -d "$homedir" ]] ; then
          echo -e "${RED}$DIR does not exist! Is /home unmounted?${NRM}" >&2
          exit 1
        fi
      fi
    done
  done
}

parse() {
  psd_state=$(systemctl --user is-active psd)
  resync_state=$(systemctl --user is-active psd-resync.timer)
  [[ "$psd_state" = "active" ]] && psd_color="${GRN}" || psd_color="${RED}"
  [[ "$resync_state" = "active" ]] && resync_color="${GRN}" || resync_color="${RED}"
  echo -e " ${BLD}Systemd service is currently ${psd_color}$psd_state${NRM}${BLD}.${NRM}"
  echo -e " ${BLD}Systemd resync-timer is currently ${resync_color}$resync_state${NRM}${BLD}.${NRM}"
  [[ $OLFS -eq 1 ]] &&
    echo -e "${BLD} Overlayfs v$OLFSVER is currently ${GRN}active${NRM}${BLD}.${NRM}" ||
    echo -e "${BLD} Overlayfs technology is currently ${RED}inactive${NRM}${BLD}.${NRM}"
  echo
  echo -e "${BLD}Psd will manage the following per ${BLU}${PSDCONF}${NRM}${BLD}:${NRM}"
  echo
  local browser
  for browser in "${BROWSERS[@]}"; do
    load_env_for "$browser"
    for item in "${DIRArr[@]}"; do
      DIR="$item"
      BACKUP="$item-backup"
      suffix=
      if suffix_needed "$browser"; then
        suffix="-${item##*/}"
      fi
      UPPER="$VOLATILE/$user-$browser${suffix}-rw"
      if [[ -d "$DIR" ]]; then
        CRASHArr=( $(find "${DIR%/*}" -type d -name '*crashrecovery*'|sort -r) )
        # get permissions on profile dir and be smart about it since symlinks are all 777
        [[ -f $PID_FILE ]] && TRUEP=$(stat -c %a "$BACKUP") || TRUEP=$(stat -c %a "$DIR")
        # since $XDG_RUNTIME_DIR is 700 by default so pass on by
        if [[ "$VOLATILE" = "$XDG_RUNTIME_DIR" ]]; then
          warn=
        else
          # using something other than $XDG_RUNTIME_DIR so check for privacy
          [[ $TRUEP -ne 700 ]] && warn=1
        fi
        # profile dir size
        psize=$(du -Dh --max-depth=0 "$DIR" 2>/dev/null | awk '{ print $1 }')
        echo -en " ${BLD}browser/psname:"
        echo -e "$(tput cr)$(tput cuf 17) $browser/$PSNAME${NRM}"
        echo -en " ${BLD}owner/group id:"
        echo -e "$(tput cr)$(tput cuf 17) $user/$group${NRM}"
        echo -en " ${BLD}sync target:"
        echo -e "$(tput cr)$(tput cuf 17) ${BLU}$DIR${NRM}"
        if [[ $warn -eq 1 ]]; then
          echo -e "$(tput cr)$(tput cuf 17) ${RED} Permissions are $TRUEP on this profile.${NRM}"
          echo -e "$(tput cr)$(tput cuf 17) ${RED} Recommend a setting of 700 for increased privacy!${NRM}"
          warn=
        fi
        echo -en " ${BLD}tmpfs dir:"
        echo -e "$(tput cr)$(tput cuf 17) ${GRN}$VOLATILE/$user-$browser$suffix${NRM}"
        echo -en " ${BLD}profile size:"
        echo -e "$(tput cr)$(tput cuf 17) $psize${NRM}"
        if [[ $OLFS -eq 1 ]]; then
          rwsize=$(du -Dh --max-depth=0 "$UPPER" 2>/dev/null | awk '{ print $1 }')
          echo -en " ${BLD}overlayfs size:"
          echo -e "$(tput cr)$(tput cuf 17) $rwsize${NRM}"
        fi
        echo -en " ${BLD}recovery dirs:"
        if [[ "${#CRASHArr[@]}" -eq 0 ]]; then
          echo -e "$(tput cr)$(tput cuf 17) none${NRM}"
        else
          echo -e "$(tput cr)$(tput cuf 17) ${RED}${#CRASHArr[@]}${NRM}${BLD} <- delete with the c option${NRM}"
          for backup in "${CRASHArr[@]}"; do
            psize=$(du -Dh --max-depth=0 "$backup" 2>/dev/null | awk '{ print $1 }')
            echo -en " ${BLD} dir path/size:"
            echo -e "$(tput cr)$(tput cuf 17) ${BLU}$backup ${NRM}${BLD}($psize)${NRM}"
          done
        fi
        unset CRASHArr
        echo
      fi
    done
  done
}

case "$1" in
  p|P|Parse|parse|Preview|preview|debug)
    dep_check
    config_check
    dup_check
    ungraceful_state_check
    header
    parse
    ;;
  c|C|clean|Clean)
    dep_check
    config_check
    dup_check
    header
    cleanup
    ;;
  sync|resync)
    if [[ -f $PID_FILE ]]; then
      do_sync
    else
      dep_check
      config_check
      dup_check
      running_check
      ungraceful_state_check
      do_sync
      enforce
    fi
    ;;
  unsync)
    if [[ -f $PID_FILE ]]; then
      do_sync
      kill_browsers
      do_unsync
    fi
    ;;
  *)
    header
    echo -e " ${BLD}$0 ${NRM}${GRN}[option]${NRM}"
    echo -e " ${BLD} ${NRM}${GRN}preview${NRM}${BLD}	Parse config file (${NRM}${BLU}${PSDCONF}${NRM}${BLD}) to see which profiles will be managed.${NRM}"
    echo -e " ${BLD} ${NRM}${GRN}clean${NRM}${BLD}		Clean (delete without prompting) ALL crashrecovery dirs for all profiles.${NRM}"
    echo
    echo -e " ${BLD}It is ${RED}HIGHLY DISCOURAGED${NRM}${BLD} to directly call $0 to sync, resync, or to unsync.${NRM}"
    echo
    if [[ -f /usr/lib/systemd/user/psd.service ]]; then
      echo -e " ${BLD}Instead, use systemd to start/stop profile-sync-daemon.${NRM}"
      echo
      echo -e " ${BLD}systemctl --user ${NRM}${GRN}[option]${NRM}${BLD} psd${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}start${NRM}${BLD}		Turn on daemon; make symlinks and actively manage targets in tmpfs.${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}stop${NRM}${BLD}		Turn off daemon; remove symlinks and rotate tmpfs data back to disc.${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}enable${NRM}${BLD}	Autostart daemon when system comes up.${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}disable${NRM}${BLD}	Remove daemon from the list of autostart daemons.${NRM}"
    elif [[ -f /etc/init.d/psd ]]; then
      echo -e " ${BLD}Instead, use the init system to start/stop profile-sync-daemon.${NRM}"
      echo
      echo -e " ${BLD}sudo service psd ${NRM}${GRN}[option]${NRM}${BLD} or /etc/init.d/psd ${NRM}${GRN}[option]${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}start${NRM}${BLD}	Turn on daemon; make symlinks and actively manage targets in tmpfs.${NRM}"
      echo -e " ${BLD} ${NRM}${GRN}stop${NRM}${BLD}	Turn off daemon; remove symlinks and rotate tmpfs data back to disc.${NRM}"
    fi
    ;;
esac
exit 0

# vim:set ts=2 sw=2 et:
