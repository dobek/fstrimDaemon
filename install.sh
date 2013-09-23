#!/bin/bash

echo Installing fstrimDemon...

DIR=`dirname $0`

cp -fv usr/sbin/fstrimDemon.sh /usr/sbin/fstrimDemon.sh
RES=$?
if [ "$RES" != "0" ]; then
	echo Must be root to install fstrimDemon
	exit $RES
fi
chmod 755 /usr/sbin/fstrimDemon.sh

if [ ! -e /etc/conf.d/fstrimDemon ]; then
	cp -v etc/conf.d/fstrimDemon /etc/conf.d/fstrimDemon
fi

cp -fv etc/init.d/fstrimDemon /etc/init.d/fstrimDemon
chmod 755 /etc/init.d/fstrimDemon

echo
echo Find more information in README.md
echo
