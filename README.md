fstrimDemon
===========

Very lightweight demon executing fstrim every few hours.


MOTIVATION:
-----------------------------------------

Usually fstrim is run from cron but cron can execute command only at particular time. If you turn off your computer you can miss it. This demon solves this problem running fstrim in the loop. It gives also very low priority to this task in order not to intrude your main activities.


INSTALLATION
-----------------------------------------

### Run as root:
```
./install.sh
```

### To start demon if you are using init.d:
```
/etc/init.d/fstrimDemon start
```

### To start demon if you are using systemd:
```
systemctl start fstrimDemon

### To start demon automatically at each boot if you are using systemd:
```
systemctl enable fstrimDemon
```

### To stop demon if you are using init.d:
```
/etc/init.d/fstrimDemon stop
```

### To uninstall run as root:
```
./uninstall.sh
```
If you are using systemd, uninstall.sh will stop and disable the demon

Files which are not removed during uninstallation:
- _/etc/conf.d/fstrimDemon_
- _/var/log/fstrimDemon.log_


CONFIGURATION
-----------------------------------------


Default config file: _/etc/conf.d/fstrimDemon_

```bash
# Directory for which fstrim will be run
TRIM_DIR="/"

# Time to wait after demon start to perform first fstrim
# e.g. "30m" - 30 minutes. See man sleep.
SLEEP_AT_START="2h"

# Time to sleep between next repetition of fstrim
# e.g. "5d" - 5 days. See man sleep.
SLEEP_BEFORE_REPEAT="3h"

# Maximum CPU Load when fstrim is allowed.
# If current CPU Load is above demon sleeps for 5 min.
# 1.0 means all cores are busy.
MAX_CPU_LOAD="0.2"

# integer [-20 .. 19 ] default 0
# change the priority of the server -20 (high) to 19 (low)
# see nice(1) for description
NICE="19"

# See start-stop-daemon(8) for possible settings
# Modifies the IO scheduling priority of the daemon.  Class
# can be 0 for none, 1 for real time, 2 for best effort and 3
# for idle.  Data can be from 0 to 7 inclusive.
IONICE="3"

# Here Demon's process id will be stored
PID="/var/run/fstrimDemon.pid"

# Here Demon logs
LOG="/var/log/fstrimeDemon.log"

# The main demon script i.e. fstrim-sleep loop
DEMON="/usr/sbin/fstrimDemon.sh"
```

LOG
-----------------------------------------

See _/var/log/fstrimDemon.log_


PROJECT HOME
-----------------------------------------

https://github.com/dobek/fstrimDemon
