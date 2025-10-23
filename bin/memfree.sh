#!/bin/bash

MEM=$(free -h | grep 'Mem:')
SWP=$(free -h | grep 'Swap:')

MEM_FREE=$(echo "$MEM" | awk '{printf "%s\n", $4}')
MEM_AVAI=$(echo "$MEM" | awk '{printf "%s\n", $7}')
SWAP_USED=$(echo "$SWP" | awk '{printf "%s\n", $3}')

# Print
echo -n "<txt>"
echo -n "mem:<span fgcolor='lightgreen'>$MEM_FREE</span>/<span fgcolor='yellow'>$MEM_AVAI</span> "
echo -n "swp:<span fgcolor='salmon'>$SWAP_USED</span>"
echo -n "</txt>"
echo

