#!/bin/bash

source /etc/conf.d/fstrimDaemon


SLEEP_CMD="sleep"
# SLEEP_CMD="echo debug: SLEEP"

# We divide sleep for smaller portions in order to protect
# against being awaken when computer resume from suspension
function vigilantSleep()
{
	local VAL=${1%?}

	if   [[ "$1" == *s ]] ; then
		local MULTIPLEXER=1
	elif [[ "$1" == *m ]] ; then
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
# echo debug: U_MAX_CPU_LOAD=${U_MAX_CPU_LOAD}

function waitForLowCpuLoad()
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

		[ `echo "${CPU_LOAD} < ${U_MAX_CPU_LOAD}" | bc -l` = 1 ] \
			&& echo "debug: CPU_LOAD=${CPU_LOAD}" \
			&& break
		sleep 5m
	done
}

function doTRIM()
{
	NC="ionice -c3 nice -n 19"
	echo `date`: RUN FSTRIM FOR ${TRIM_DIRS}
	for DIR in ${TRIM_DIRS}; do
		waitForLowCpuLoad
		time $NC fstrim -v ${DIR}
	done
	echo ----------------------------
}


if [ "$1" != "one_shot" ]; then
	echo =============================
	echo `date`: FSTRIM DAEMON STARTED
	echo -----------------------------
	vigilantSleep ${SLEEP_AT_START}
fi

echo "Searching for trimable directories"
TRIM_DIRS=
for mount_point in `mount | grep -E "type ext|type bfs|type msdos|type fat|type vfat" | cut -d" " -f3`
do
	fstrim ${mount_point} 2> /dev/null
	if [ "$?" = "0" ] ; then
		TRIM_DIRS="${TRIM_DIRS} ${mount_point}"
	fi
done
echo Trimable directories are: ${TRIM_DIRS}


if [ "$1" == "one_shot" ]; then
	echo "One shot done"
	exit 0
fi


while true ; do
	vigilantSleep ${SLEEP_BEFORE_REPEAT}
	doTRIM
done
