#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")"

if [ ! -f "~/.zshrc" ]; then
    ln -s $(pwd)/zshrc $HOME/.zshrc
fi

