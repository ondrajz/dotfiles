#!/bin/bash

NAME=`domainname -A`
IPS=`hostname -I`

echo "<txt>domain name: <span fgcolor='thistle'>${NAME}</span>
host IPs: <span fgcolor='slategray1'>${IPS}</span></txt>"

