#!/bin/bash

BTC=$(curl -s https://blockchain.info/ticker | jq -r '.EUR.last')
TRANS=$(curl -s https://blockchain.info/q/24hrtransactioncount)
TRANS=`echo $(($TRANS/1000))`

echo "<txt>BTC: <span fgcolor='khaki'>€${BTC}</span>
trans: <span fgcolor='darkgrey'>${TRANS}k</span></txt>"

