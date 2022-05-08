#!/bin/sh

set -e
n=''
if [ -f "/phonebook.txt" ]; then
    for i in `cat /phonebook.txt`; do
        n="$n -n$i "
    done
fi
sed -e "s/<IP_SERVER>/${IP_SERVER}/" -e "s/<IP_CLIENT>/${IP_CLIENT}/" /ppp_options > /etc/ppp/options
/usr/bin/tcpser -i"&c0" -l4 -s ${BAUD} -d ${DEV} -n ${PPP_PHONE}=127.0.0.1:2323 $n &
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
dnsmasq &

rm -f /pppd-fifo
mkfifo /pppd-fifo
while true ; do
    cat /pppd-fifo | /usr/sbin/pppd 2>&1 | nc -l -p 2323 > /pppd-fifo
done
