#!/bin/sh

[ -e "/tmp/all-to-cron.log" ] && return 0

. /data/custom/common/custom_funcs.sh

mount_overlay

copy_root

start_ssh

update_zapret_rules

d=$(date) ; echo "all-to-cron $d" >> /tmp/all-to-cron.log