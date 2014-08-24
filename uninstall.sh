#!/bin/bash

echo Uninstalling fstrimDaemon...

rm -fv /usr/sbin/fstrimDaemon.sh
RES=$?
if [ "$RES" != "0" ]; then
	echo Must be root to install fstrimDaemon
	exit $RES
fi

rm -fv /etc/init.d/fstrimDaemon

if [ -e /usr/bin/systemctl ]; then
	/usr/bin/systemctl stop fstrimDaemon
	/usr/bin/systemctl disable fstrimDaemon
fi

rm -fv /usr/lib/systemd/system/fstrimDaemon.service

echo
echo You can manually remove:
echo - /etc/conf.d/fstrimDaemon
echo - /var/log/fstrimDaemon.log
echo
echo Find more information in README.md
echo
