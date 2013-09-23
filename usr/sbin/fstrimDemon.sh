#!/bin/bash

source /etc/conf.d/fstrimDemon

SLEEP_CMD="sleep"
# SLEEP_CMD="echo debug: SLEEP"

# We divide sleep for smaller portions in order to protect
# against being awaken when computer resume from suspension
vigilanSleep()
{
	local VAL=${1%?}

	if   [[ "$1" == *m ]] ; then
		local MULTIPLEXER=60
	elif [[ "$1" == *h ]] ; then
		local MULTIPLEXER=60*60
	elif [[ "$1" == *d ]] ; then
		local MULTIPLEXER=24*60*60
	else
		local MULTIPLEXER=1
		local VAL=${1}
	fi

	let "HOURS= ${VAL} * ${MULTIPLEXER} / ${SLEEP_CHUNK}"
	let " REST= ${VAL} * ${MULTIPLEXER} % ${SLEEP_CHUNK}"

	for i in $(seq 1 ${HOURS}) ; do
		${SLEEP_CMD} ${SLEEP_CHUNK}
	done

	${SLEEP_CMD} ${REST}
}


##############################


echo `date`: FSTRIM DEMON STARTED
echo ----------------------------
vigilanSleep ${SLEEP_AT_START}

while true ; do
	echo `date`: RUN FSTRIM FOR ${TRIM_DIR}
	time fstrim -v ${TRIM_DIR}
	echo ----------------------------
	vigilanSleep ${SLEEP_BEFORE_REPEAT}
done
