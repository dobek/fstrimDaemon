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


CORES=`grep 'model name' /proc/cpuinfo | wc -l`
U_MAX_CPU_LOAD=`echo "0${CORES} * 0${MAX_CPU_LOAD}" | bc -l`
#echo debug: U_MAX_CPU_LOAD=${U_MAX_CPU_LOAD}

waitForLowCpuLoad()
{
	local CPU_LOAD=999999
	while true ; do
		local CPU_LOAD=`cut -f 1 -d" " /proc/loadavg`
		local TMP=`cut -f 2 -d" " /proc/loadavg`
		local DIFF=`echo "${CPU_LOAD} < ${TMP}" | bc -l`
		if [ `echo "${CPU_LOAD} < ${TMP}" | bc -l` = 1 ] ; then
			local CPU_LOAD=${TMP}
		fi
		local TMP=`cut -f 3 -d" " /proc/loadavg`
		if [ `echo "${CPU_LOAD} < ${TMP}" | bc -l` = 1  ] ; then
			local CPU_LOAD=${TMP}
		fi

		[ `echo "${CPU_LOAD} < ${U_MAX_CPU_LOAD}" | bc -l` = 1 ] && break
		sleep 5m
	done
}


##############################

echo `date`: FSTRIM DEMON STARTED
echo ----------------------------
vigilanSleep ${SLEEP_AT_START}

while true ; do
	echo `date`: RUN FSTRIM FOR ${TRIM_DIR}
	waitForLowCpuLoad
	time fstrim -v ${TRIM_DIR}
	echo ----------------------------
	vigilanSleep ${SLEEP_BEFORE_REPEAT}
done
