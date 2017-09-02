#!/bin/zsh

proxy::http::open(){
    export http_proxy="127.0.0.1:1087"
    export https_proxy="127.0.0.1:1087"
}

proxy::http::close(){
    export http_proxy=""
    export https_proxy=""
}
