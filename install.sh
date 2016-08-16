#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

if [ ! -f "~/.zshrc" ]; then
    ln -ris zshrc "~/.zshrc"
fi

