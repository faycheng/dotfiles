#!/bin/zsh

FILE_PATH=$(realpath "$0")
FILE_DIR=$(dirname $FILE_PATH)
WORKS_DIR=$FILE_DIR/private/works

workon() {
    work=$1
    if [ -f $WORKS_DIR/$work.sh ]; then
        source $WORKS_DIR/$work.sh
        return 0
    fi
    echo "Path($WORKS_DIR/$work.sh) not found"
}