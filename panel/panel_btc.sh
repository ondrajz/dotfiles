#!/bin/bash

BTC=$(curl -s https://blockchain.info/ticker | jq -r '.EUR.last')
TRANS=$(curl -s https://blockchain.info/q/24hrtransactioncount)
TRANS=`echo $(($TRANS/1000))`

echo "<txt>btc: <span fgcolor='darkkhaki'>€${BTC}</span>
trans: <span fgcolor='darkslategray4'>${TRANS}k</span></txt>"

