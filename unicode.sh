#!/bin/bash
x=(0 1 2 3 4 5 6 7 8 9 A B C D E F)
for a in {0..15}; do for b in {0..15}; do for c in {0..15}; do
        [[ $a -eq 0 && $b -eq 0 && $c -lt 2 ]] && continue
        [[ $c -eq 0 ]] && echo; echo -en "\n\n${x[$a]}${x[$b]}${x[$c]}X: "
        for d in {0..15}; do
                echo -en "\u${x[$a]}${x[$b]}${x[$c]}${x[$d]}   "
        done
done; done; done
