#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User settings
export EDITOR="nvim"
alias vim='nvim'

# Tab-completion
complete -c man which
complete -cf sudo

# Line wrap on window resize
shopt -s checkwinsize

# Import/refresh colorscheme from 'wal' (termite)
#(wal -r -t &)
