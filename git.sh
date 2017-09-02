#!/bin/zsh

alias gs="git status"
alias gd="git diff "
alias ga="git add "
alias gc="git commit -m "
alias gl="git log"
alias gp="git push origin "

gb(){
    branch_type=$1
    branch_name=$2
    if [ $branch_type = 'feature' ]; then
        git checkout -b feature/$branch_name
    fi
    if [ $branch_type = 'hotfix' ]; then
        git checkout -b hotfix/$branch_name
    fi
}

compctl -k '(feature hotfix)' gb