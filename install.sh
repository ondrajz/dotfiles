#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -a ~/.bash_aliases ]; then
    ln -s $DIR/bash/.bash_aliases ~
fi

