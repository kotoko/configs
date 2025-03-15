#!/bin/bash

INTERFACE="$1"
ACTION="$2"
CHRONY_ADDTIONAL_DIR='/run/chrony-dhcp-ntp'

mkdir -p "${CHRONY_ADDTIONAL_DIR}"

[ -z "${CONNECTION_UUID}" ] && exit 0

case "${ACTION}" in
        up | dhcp4-change | dhcp6-change)
                if [ -n "${DHCP4_NTP_SERVERS}" ]; then
                        echo "Will add the ntp server $DHCP4_NTP_SERVERS"
                else
                        echo "No DHCP4 NTP available."
                        exit 0
                fi

                for s in ${DHCP4_NTP_SERVERS}; do
                        echo "server ${s} iburst" >> "${CHRONY_ADDTIONAL_DIR}/${CONNECTION_UUID}.sources"
                        break  # use only first ntp server from dhcp -> avoid potential spam of servers
                done

                chmod 644 "${CHRONY_ADDTIONAL_DIR}/*.sources"
                chmod 755 "${CHRONY_ADDTIONAL_DIR}"

                /usr/bin/chronyc reload sources
                ;;

        down)
                rm -f "${CHRONY_ADDTIONAL_DIR}/${CONNECTION_UUID}.sources"

                /usr/bin/chronyc reload sources
                ;;
esac
echo 'Done!'
