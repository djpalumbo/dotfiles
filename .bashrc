#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User settings
alias vim='nvim'

# Tab-completion
complete -cf sudo

# Line wrap on window resize
shopt -s checkwinsize
