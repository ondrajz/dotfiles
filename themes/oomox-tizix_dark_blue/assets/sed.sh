#!/bin/sh
sed -i \
         -e 's/#181a1e/rgb(0%,0%,0%)/g' \
         -e 's/#dcdcdc/rgb(100%,100%,100%)/g' \
    -e 's/#1d2024/rgb(50%,0%,0%)/g' \
     -e 's/#12577a/rgb(0%,50%,0%)/g' \
     -e 's/#272b30/rgb(50%,0%,50%)/g' \
     -e 's/#dcdcdc/rgb(0%,0%,50%)/g' \
	*.svg
