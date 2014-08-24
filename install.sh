#!/bin/bash

echo Installing fstrimDaemon...

DIR=`dirname $0`

cp -fv usr/sbin/fstrimDaemon.sh /usr/sbin/fstrimDaemon.sh
RES=$?
if [ "$RES" != "0" ]; then
	echo Must be root to install fstrimDaemon
	exit $RES
fi
chmod 755 /usr/sbin/fstrimDaemon.sh

if [ ! -e /etc/conf.d/fstrimDaemon ]; then
	cp -v etc/conf.d/fstrimDaemon /etc/conf.d/fstrimDaemon
fi

cp -fv etc/init.d/fstrimDaemon /etc/init.d/fstrimDaemon
chmod 755 /etc/init.d/fstrimDaemon

cp -fv usr/lib/systemd/system/fstrimDaemon.service /usr/lib/systemd/system/fstrimDaemon.service
chmod 755 /usr/lib/systemd/system/fstrimDaemon.service

echo
echo Find more information in README.md
echo
