#!/bin/bash

source /etc/conf.d/fstrimDemon

echo STARTED: `date`
sleep ${SLEEP_AT_START}

while true ; do
	echo GO: `date`
	time fstrim -v ${TRIM_DIR}
	echo
	sleep ${SLEEP_BEFORE_REPEAT}
done
