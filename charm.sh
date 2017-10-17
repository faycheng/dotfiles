#!/bin/zsh

function charm() {
    if [ $# = 0 ]; then
        charm ./
    fi
    /usr/local/bin/charm $@
}

