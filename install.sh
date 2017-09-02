#!/bin/zsh

FILE_PATH=$(realpath "$0")
FILE_DIR=$(dirname $FILE_PATH)

proxy::http::open(){
    export http_proxy="127.0.0.1:1087"
    export https_proxy="127.0.0.1:1087"
}

proxy::http::close(){
    export http_proxy=""
    export https_proxy=""
}

command::exist(){
    command=$1
    type_res=$(type "$command")
    if [[ $type_res == *"not found"* ]]; then
        echo False
        return 0
    fi
    echo True
}

install::pip(){
    if [ "$(command::exist pip)" = "False" ]; then
        sudo -H python $FILE_DIR/get-pip.py
    fi
}

install::python::virtualenv(){
    sudo -H pip install virtualenv
}

install::python::six(){
    echo y | sudo -H pip install --ignore-installed six
}

install::python::fire(){
    sudo -H pip install fire
}

install::python::prompt_toolkit(){
    sudo -H pip install prompt_toolkit
}

install::oh_my_zsh(){
    if [ "$(command::exist zsh)" = "False" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    brew install zsh-autosuggestions
    brew install zsh-syntax-highlighting
}

install::wget(){
    if [ "$(command::exist wget)" = "False" ]; then
        brew install wget
    fi
}

install::jq(){
    if [ "$(command::exist jq)" = "False" ]; then
        brew install jq
    fi
}

install::python3(){
    if [ "$(command::exist python3)" = "False" ]; then
        brew install python3
    fi
}
#
#install::autojump(){
#    if [ "$(command::exist autojump)" = "False" ]; then
#        brew install autojump
#    fi
#}


install::coreutils(){
    brew install coreutils
}

install::corkscrew(){
    if [ "$(command::exist corkscrew)" = "False" ]; then
        brew install corkscrew
    fi
}

install::git(){
    if [ "$(command::exist git)" = "False" ]; then
        brew install git
    fi
}

install::go(){
    if [ "$(command::exist go)" = "False" ]; then
        brew install go
    fi
}

install::htop(){
    if [ "$(command::exist htop)" = "False" ]; then
        brew install htop
    fi
}

install::wrk(){
    if [ "$(command::exist wrk)" = "False" ]; then
        brew install wrk
    fi
}

install::fuck(){
    if [ "$(command::exist fuck)" = "False" ]; then
        brew install thefuck
    fi
}


link::zshrc(){
    if [ -f $HOME/.zshrc ];then
        echo -n "Remove $HOME/.zshrc (y/n)?"
        read confirm
        if [ ! $confirm = 'y' ];then
            exit 1
        fi
        mv $HOME/.zshrc $HOME/.zshrc.bak
    fi
    ln -s $FILE_DIR/launch.sh $HOME/.zshrc
    echo Link zshrc success
}


main(){
    proxy::http::open

    install::wget
    install::jq
    install::oh_my_zsh
    install::coreutils
    install::corkscrew
    install::git
    install::go
    install::htop
    install::wrk


    install::python3
    install::pip

    install::python::six
    install::python::virtualenv
    install::python::fire
    install::python::prompt_toolkit

    link::zshrc

    proxy::http::close
}


main