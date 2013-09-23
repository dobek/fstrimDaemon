#!/bin/bash

source /etc/conf.d/fstrimDemon

echo `date`: FSTRIM DEMON STARTED
echo ----------------------------
sleep ${SLEEP_AT_START}

while true ; do
	echo `date`: RUN FSTRIM FOR ${TRIM_DIR}
	time fstrim -v ${TRIM_DIR}
	echo ----------------------------
	sleep ${SLEEP_BEFORE_REPEAT}
done
