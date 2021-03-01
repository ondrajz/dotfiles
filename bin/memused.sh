#!/bin/bash
free -m | grep Mem: | awk '{printf "%s/%sMB\n", $3, $2}'
