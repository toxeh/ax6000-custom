#!/bin/sh

[ -e "/tmp/all-to-cron.log" ] && return 0

/data/custom/set-overlay.sh
/data/custom/copy-root.sh

. /lib/functions/preinit.sh

nvram set ssh_en=1
nvram commit

/etc/init.d/dropbear enable
/etc/init.d/dropbear start
/etc/init.d/tpws restart

d=$(date) ; echo "all-to-cron $d" >> /tmp/all-to-cron.log