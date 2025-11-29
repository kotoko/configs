#!/bin/bash

set -eo pipefail
set -x

# configure apt
cp -vf '/host/sources.list.txt' '/etc/apt/sources.list'

# copy scripts
cp -vf '/host/dump-ldap-hashes.sh.template' '/root/dump-ldap-hashes.sh.template'
cp -vf '/host/crack-passwords.py.template' '/root/crack-passwords.py.template'
cp -vf '/host/send-notifications.py.template' '/root/send-notifications.py.template'
cp -vf '/host/run-app.sh' '/root/run-app.sh'
cp -vf '/host/kurwayou.txt' '/root/kurwayou.txt'  #source: https://github.com/MagicFloppy/kurwayou.txt

# install john the ripper
export DEBIAN_FRONTEND="noninteractive"
apt update
apt upgrade -y
apt --fix-broken install -y
apt install -y vim john ldap-utils procps cronie htop bash python3 sed locales-all tzdata
dpkg -i '/host/run-one_1.17-0ubuntu2_all.deb'

# configure cron
cat -<<EOF > '/etc/cron.d/crack-passwords-labnet'
@hourly      root  /usr/bin/run-one /usr/bin/python3 /root/crack-passwords.py
0 6 2 * *    root  /usr/bin/run-one /usr/bin/python3 /root/send-notifications.py
0 6 16 * *   root  /usr/bin/run-one /usr/bin/python3 /root/send-notifications.py
EOF

# letsencrypt ca
mkdir -p '/usr/local/share/ca-certificates/'
cat -<<EOF > '/usr/local/share/ca-certificates/isrg-root-x2.crt'
-----BEGIN CERTIFICATE-----
MIICGzCCAaGgAwIBAgIQQdKd0XLq7qeAwSxs6S+HUjAKBggqhkjOPQQDAzBPMQsw
CQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJuZXQgU2VjdXJpdHkgUmVzZWFyY2gg
R3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBYMjAeFw0yMDA5MDQwMDAwMDBaFw00
MDA5MTcxNjAwMDBaME8xCzAJBgNVBAYTAlVTMSkwJwYDVQQKEyBJbnRlcm5ldCBT
ZWN1cml0eSBSZXNlYXJjaCBHcm91cDEVMBMGA1UEAxMMSVNSRyBSb290IFgyMHYw
EAYHKoZIzj0CAQYFK4EEACIDYgAEzZvVn4CDCuwJSvMWSj5cz3es3mcFDR0HttwW
+1qLFNvicWDEukWVEYmO6gbf9yoWHKS5xcUy4APgHoIYOIvXRdgKam7mAHf7AlF9
ItgKbppbd9/w+kHsOdx1ymgHDB/qo0IwQDAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0T
AQH/BAUwAwEB/zAdBgNVHQ4EFgQUfEKWrt5LSDv6kviejM9ti6lyN5UwCgYIKoZI
zj0EAwMDaAAwZQIwe3lORlCEwkSHRhtFcP9Ymd70/aTSVaYgLXTWNLxBo1BfASdW
tL4ndQavEi51mI38AjEAi/V3bNTIZargCyzuFJ0nN6T5U6VR5CmD1/iQMVtCnwr1
/q4AaOeMSQ+2b1tbFfLn
-----END CERTIFICATE-----
EOF
/usr/sbin/update-ca-certificates

# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*
