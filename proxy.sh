#!/bin/zsh

proxy="http://127.0.0.1:1235"

_proxy::http::open(){
    export http_proxy="$proxy"
    export https_proxy="$proxy"
}

_proxy::http::close(){
    export http_proxy=""
    export https_proxy=""
}

proxy(){
    case $1 in
    "open" )
        _proxy::http::open
        env | grep proxy
        ;;
    "close" )
        _proxy::http::close
        env | grep proxy
        ;;
    *)
        echo "Usage: proxy COMMAND"
        echo "Default: $proxy\n"
        echo "Management Commands:"
        printf "%-10s %-30s\n" open "open http proxy"
        printf "%-10s %-30s\n" close "close http proxy"
        ;;
     esac
}

compctl -k '(open close)' proxy