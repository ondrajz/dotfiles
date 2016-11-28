#!/bin/bash

BTC=$(curl -s https://blockchain.info/ticker | jq -r '.EUR.last')
TRANS_24=$(curl -s https://blockchain.info/q/24hrtransactioncount)
TRANS_UNC=$(curl -s https://blockchain.info/q/unconfirmedcount)
TRANS_24=`echo $(($TRANS_24/1000))`
TRANS_UNC=`echo $(($TRANS_UNC/1000))`

echo "<txt>btc: <span fgcolor='darkkhaki'>€${BTC}</span>
tran: <span fgcolor='darkslategray3'>${TRANS_24}k</span> <span fgcolor='lightgray'>(${TRANS_UNC}k)</span></txt>"

