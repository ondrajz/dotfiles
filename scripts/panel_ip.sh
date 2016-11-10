#!/bin/bash

IPINFO="http://ipinfo.io/ip"

NET_IF="enp4s0"
NET_FILE="$HOME/.ipinfo_${NET_IF}"

EXT_FILE="$HOME/.ipinfo_external"
ETH_FILE="$HOME/.ipinfo_local"

ETH_CLR="darkcyan"
EXT_CLR="lightskyblue"

ifconfig $NET_IF | tee "$NET_FILE" | grep -q inet; res=$?
if [ $res -eq 0 ]; then
    cat $NET_FILE | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' > $ETH_FILE
else
    ETH_CLR="red"
    echo "error $res" > $ETH_FILE
fi

wget $IPINFO -qO $EXT_FILE; res=$?
if [ $res -ne 0 ]; then
    EXT_CLR="red"
    ERR="error $res"
    if [ $res -eq 4 ]; then
        ERR="network fail"
    fi
    echo "$ERR" > $EXT_FILE
fi

EXT=`cat $EXT_FILE`
ETH=`cat $ETH_FILE`

echo "<txt>ext: <span fgcolor='${EXT_CLR}'>${EXT}</span>
loc: <span fgcolor='${ETH_CLR}'>${ETH}</span></txt>"

