

mount_overlay() {

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

  d=$(date) ; echo "overlay enabled $d" >> /tmp/set-custom.log
}

copy_root() {
  cp -Rf /data/custom/root/* /
  d=$(date) ; echo "copy root $d" >> /tmp/set-custom.log
}

start_ssh() {
  . /data/custom/settings
  if [[ "$CUSTOM_SSH" -eq 1 ]]; then
      nvram set ssh_en=1
      nvram commit

      /etc/init.d/dropbear enable
      /etc/init.d/dropbear start
      d=$(date) ; echo "start dropbear $d" >> /tmp/set-custom.log
  fi
}

update_zapret_rules() {
  . /data/custom/settings
  . /data/custom/zapret/conf/zapret.conf

  mkdir /tmp/zapret_conf
  cd /tmp/zapret_conf
  rm ./zapret.conf >/dev/null 2>&- &&
  echo get config for ${ZAPRET_PROVIDER}
  curl -L -O https://raw.githubusercontent.com/toxeh/ax6000-custom/refs/heads/${ZAPRET_PROVIDER}/data/custom/zapret/conf/zapret.conf

  grep -m1 'CUSTOM_ZAPRET=' /tmp/zapret_conf/zapret.conf >/dev/null 2>&- && mv /tmp/zapret_conf/zapret.conf /data/custom/zapret/conf/zapret.conf >/dev/null 2>&-
  d=$(date) ; echo "update zapret rules $d" >> /tmp/set-custom.log
  cd /tmp
  #rm -rf /tmp/zapret_conf
  restart_zapret
}

restart_zapret() {

  /data/custom/zapret/init.d/nfqws stop
  /data/custom/zapret/init.d/tpws stop

  . /data/custom/zapret/conf/zapret.conf


  if [[ "$CUSTOM_ZAPRET" == "TPWS" ]]; then
      /data/custom/zapret/init.d/tpws start
  elif [[ "$CUSTOM_ZAPRET" == "NFQWS" ]]; then
      /data/custom/zapret/init.d/nfqws start
  fi
  d=$(date) ; echo "restart zapret $d" >> /tmp/set-custom.log
}

