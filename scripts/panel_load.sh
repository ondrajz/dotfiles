#!/bin/bash

Duration () {
  local T=$1
  
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))

  if [[ $D > 0 ]]; then 
    [[ $D == 1 ]] && echo -n "$D day " || echo -n "$D days "
  fi
  printf '%d:%02d:%02d' $H $M $S
}

UPTIME="$(Duration `cat /proc/uptime | awk -F"." '{print $1}'`)"
LOAD=$(cat /proc/loadavg | awk '{ printf "%s / %s / %s", $1, $2, $3 }')

echo "<txt>up: <span fgcolor='khaki'>$UPTIME</span>
load: <span fgcolor='tan'>$LOAD</span></txt>"

