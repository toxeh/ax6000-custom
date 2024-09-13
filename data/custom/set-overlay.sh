#!/bin/sh

[ -e "/tmp/set-overlay.log" ] && return 0

. /lib/functions/preinit.sh

[ -e /data/overlay ] || mkdir /data/overlay
[ -e /data/overlay/upper ] || mkdir /data/overlay/upper
[ -e /data/overlay/work ] || mkdir /data/overlay/work

mount --bind /data/overlay /overlay
fopivot /overlay/upper /overlay/work /rom 1

#Fixup miwifi misc, and DO NOT use /overlay/upper/etc instead, /etc/uci-defaults/* may be already removed
/bin/mount -o noatime,move /rom/data /data 2>&-
/bin/mount -o noatime,move /rom/etc /etc 2>&-
/bin/mount -o noatime,move /rom/ini /ini 2>&-
/bin/mount -o noatime,move /rom/userdisk /userdisk 2>&-

d=$(date) ; echo "overlay enabled $d" >> /tmp/set-overlay.log