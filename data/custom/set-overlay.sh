#!/bin/sh

[ -e "/tmp/set-overlay.log" ] && return 0

if [ ! -d "/data/overlay" ]; then
    mkdir /data/overlay
fi

if [ ! -d "/data/overlay/upper" ]; then
    mkdir /data/overlay/upper
fi

if [ ! -d "/data/overlay/work" ]; then
    mkdir /data/overlay/work
fi

. /lib/functions/preinit.sh

mount --bind /data/overlay /overlay
fopivot /overlay/upper /overlay/work /rom 1

mount -o noatime,move /rom/data /data >/dev/null 2>&1
mount -o noatime,move /rom/ini /ini >/dev/null 2>&1
mount -o noatime,move /rom/etc /etc >/dev/null 2>&1
mount -o noatime,move /rom/userdisk /userdisk >/dev/null 2>&1

d=$(date) ; echo "overlay enabled $d" >> /tmp/set-overlay.log