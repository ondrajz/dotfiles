#!/bin/bash

BTC=$(curl -s https://blockchain.info/ticker | jq -r '.EUR.last')
BTC_ROUND=$(LC_NUMERIC="en_US.UTF-8" printf '%.1f' "${BTC}")
TRANS_24=$(curl -s https://blockchain.info/q/24hrtransactioncount)
TRANS_UNC=$(curl -s https://blockchain.info/q/unconfirmedcount)
TRANS_24=`echo $(($TRANS_24/1000))`
if [ ${TRANS_UNC} -gt 9999 ]; then
    TRANS_UNC=`echo $(($TRANS_UNC/1000))k`
fi

echo "<txt>btc: <span fgcolor='darkkhaki'>${BTC_ROUND}€</span>
tran: <span fgcolor='darkslategray3'>${TRANS_24}k</span> <span fgcolor='lightgray'>(${TRANS_UNC})</span></txt>"

