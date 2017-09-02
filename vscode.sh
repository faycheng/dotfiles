#!/bin/zsh

function vs () {
    if [ $# = 0 ]; then
        open -a "Visual Studio Code" ./
    fi
    local target_path="$1"
    if [ -d $target_path ] || [ -f $target_path ]; then
        open -a "Visual Studio Code" "$target_path"
    else
        echo Path $target_path not exist
    fi
}

