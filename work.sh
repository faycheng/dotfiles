#!/bin/zsh

FILE_PATH=$(realpath "$0")
FILE_DIR=$(dirname $FILE_PATH)
WORKS_DIR=$FILE_DIR/private/works

workon() {
    work=$1
    if [ -z $work ]; then
        echo 'work name is empty'
        echo 'Usage:'
        echo 'workon WORK_NAME'
        return 0
    fi
    if [ -f $WORKS_DIR/$work.sh ]; then
        source $WORKS_DIR/$work.sh
        return 0
    fi
    fuzzy_work=$(ls $WORKS_DIR | grep $work | head -n 1)
    if [ ! -z $fuzzy_work ]; then
        source $WORKS_DIR/$fuzzy_work
        return 0
    fi
    echo "Path($WORKS_DIR/$work.sh) not found"
}

alias wo=workon