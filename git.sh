#!/bin/zsh

alias gs="git status"
alias gd="git diff "
alias ga="git add "
alias gc="git commit -m "
alias gl="git log"

gp() {
    git push origin $(git branch | awk -F ' ' '{{print $2}}')
}

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


gg() {
    namespace=$1
    repo_name=$2
    if [ -z $repo_name ] || [ -z $namespace ]; then
        echo 'gg NAMESPACE REPO'
        return 1
    fi
    mkdir $repo_name
    cd $repo_name
    echo "# $repo_name" >> README.md
    git init
    git add README.md
    git commit -m 'init README'
    git remote add origin https://github.com/$namespace/$repo_name.git
    git push origin master

}
compctl -k '(feature hotfix)' gb