#!/bin/bash

MEM_FREE=$(free -m | grep Mem: | awk '{printf "%sMB\n", $4}')
MEM_AVAI=$(free -m | grep Mem: | awk '{printf "%sMB\n", $7}')
SWAP_USED=$(free -m | grep Swap: | awk '{printf "%sMB\n", $3}')

echo "<txt>free: <span fgcolor='lightgreen'>$MEM_FREE</span> / <span fgcolor='yellow'>$MEM_AVAI</span> swap: <span fgcolor='salmon'>$SWAP_USED</span></txt>"

