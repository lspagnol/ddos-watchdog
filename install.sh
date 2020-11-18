#!/bin/bash

for p in at iptables ipset logtail ; do
	dpkg -l ${p} 2>/dev/null >/dev/null || apt -y install ${p}
done

chown root:root *
chmod +x ddos-watchdog.daemon
chmod +x ddos-watchdog

mkdir -p /usr/local/ddos-watchdog/sbin
mkdir -p /usr/local/ddos-watchdog/etc

[ -f /usr/local/ddos-watchdog/etc/ddos-watchdog.conf ] || cp ddos-watchdog.conf.dist /usr/local/ddos-watchdog/etc/ddos-watchdog.conf

cp ddos-watchdog.daemon /usr/local/ddos-watchdog/sbin
cp ddos-watchdog /etc/init.d
cp ddos-watchdog /usr/local/ddos-watchdog/sbin

ln -fs /usr/local/ddos-watchdog/sbin/ddos-watchdog /usr/local/sbin

cat<<EOT
DDOS watchdog is installed
Please edit '/usr/local/ddos-watchdog/etc/ddos-watchdog.conf'
Enable daemon 'update-rc.d -f ddos-watchdog defaults'

Usage: ddos-watchdog test|status|reload|start|stop|restart

test:    run ddos-watchdog in front, do not send mail or restrict acces
status:  shows state of daemon
reload:  update ip whitelist
start:   stat daemon
stop:    stop daemon
restart: restart daemon

EOT
