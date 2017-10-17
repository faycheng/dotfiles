#!/bin/zsh


# ZSH
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

HISTSIZE=1000000000
SAVEHIST=1000000000
ZSH_THEME="robbyrussell"

plugins=(zsh-autosuggestions zsh-syntax-highlighting pip python redis-cli sublime docker encode64 autojump)



export ZSH=$HOME/.oh-my-zsh		# Path to your oh-my-zsh installation.
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"




export DOTFILES_DIR=$(dirname $(readlink $HOME/.zshrc))
source $DOTFILES_DIR/git.sh
source $DOTFILES_DIR/proxy.sh
source $DOTFILES_DIR/vscode.sh
source $DOTFILES_DIR/venv.sh
source $DOTFILES_DIR/work.sh
source $DOTFILES_DIR/charm.sh


proxy open
clear


if [ -f $DOTFILES_DIR/conf.json ]; then
    WORK_DIR=$(jq -r '.work_dir' $DOTFILES_DIR/conf.json)
    if [ -d $HOME/$WORK_DIR ]; then
        export WORK_DIR=$WORK_DIR
        if [ "$PWD" = "$HOME" ]; then
            cd $HOME/$WORK_DIR
        fi
    fi
    WORK_VENV=$(jq -r '.work_venv' $DOTFILES_DIR/conf.json)
    if [ ! -z $WORK_VENV ] || [ ! $WORK_VENV = " " ] || [ ! $WORK_VENV = "\n" ];then
        venv activate $WORK_VENV
    fi

fi


if [ -f $DOTFILES_DIR/private/alias.sh ]; then
    source $DOTFILES_DIR/private/alias.sh
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
