#!/bin/bash

IPINFO="http://ipinfo.io/ip"

# TODO: list all default routes
NET_IF=$(route | grep '^default' | grep -o '[^ ]*$' | grep -v '^tun' | head -n1)
NET_FILE="/tmp/ipinfo_${NET_IF}"

EXT_FILE="/tmp/ipinfo_external"
ETH_FILE="/tmp/ipinfo_local"

ETH_CLR="darkgray"
EXT_CLR="lightskyblue"

ifconfig "$NET_IF" | tee "$NET_FILE" | grep -q inet 2>/dev/null; res=$?
if [ $res -eq 0 ]; then
    cat $NET_FILE | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > $ETH_FILE
else
    ETH_CLR="red"
    echo "error $res" > $ETH_FILE
fi

test `find "$EXT_FILE" -type f -mmin -1 -print -quit` || {
	/usr/bin/curl -sSfL $IPINFO > $EXT_FILE; res=$?
	if [ $res -ne 0 ]; then
		ERR="error $res"
		if [ $res -eq 4 ]; then
		    ERR="network fail"
		fi
		echo "$ERR" > $EXT_FILE
	fi
}

EXT=`cat $EXT_FILE`
grep error "$EXT_FILE" && EXT_CLR="red"

EXTH=`grep $EXT /etc/hosts | awk '{print $2}'`
[ -n "$EXTH" ] && EXT="$EXT ($EXTH)"
ETH=`cat $ETH_FILE`
[ -n "$NET_IF" ] && ETH="$ETH ($NET_IF)"

echo "<txt>def: <span fgcolor='${ETH_CLR}'>${ETH}</span>
pub: <span fgcolor='${EXT_CLR}'>${EXT}</span></txt>"

