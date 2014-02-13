#!/bin/bash

echo Uninstalling fstrimDemon...

rm -fv /usr/sbin/fstrimDemon.sh
RES=$?
if [ "$RES" != "0" ]; then
	echo Must be root to install fstrimDemon
	exit $RES
fi

rm -fv /etc/init.d/fstrimDemon

if [ -e /usr/bin/systemctl ]; then
	/usr/bin/systemctl stop fstrimDemon
	/usr/bin/systemctl disable fstrimDemon
fi

rm -fv /usr/lib/systemd/system/fstrimDemon.service

echo
echo You can manually remove:
echo - /etc/conf.d/fstrimDemon
echo - /var/log/fstrimDemon.log
echo
echo Find more information in README.md
echo
