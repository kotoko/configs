#!/bin/bash

set -ue

cp -vf '/root/dump-ldap-hashes.sh.template' '/root/dump-ldap-hashes.sh'
sed --in-place "s#XXX_PLACEHOLDER_PASSWORD_XXX#${LDAP_PASSWORD}#" '/root/dump-ldap-hashes.sh'

cp -vf '/root/crack-passwords.py.template' '/root/crack-passwords.py'
sed --in-place "s#XXX_PLACEHOLDER_JOHN_CPUS_XXX#${JOHN_CPUS}#" '/root/crack-passwords.py'

cp -vf '/root/send-notifications.py.template' '/root/send-notifications.py'
sed --in-place "s#XXX_PLACEHOLDER_LOGIN_XXX#${MAIL_LOGIN}#" '/root/send-notifications.py'
sed --in-place "s#XXX_PLACEHOLDER_PASSWORD_XXX#${MAIL_PASSWORD}#" '/root/send-notifications.py'

echo "Starting cron daemon..."
/usr/sbin/crond -n -s
