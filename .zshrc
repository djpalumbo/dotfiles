# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' matcher-list ''
zstyle :compinstall filename '/home/dave/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# Use Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# Import/refresh colorscheme from 'wal' (termite)
if [ $TERM = 'xterm-termite' ]
then
  (cat ~/.cache/wal/sequences &)
fi

# Short delay to change mode after hitting Esc key
export KEYTIMEOUT=1

# Settings via .Xresources
export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
bindkey ';5D' backward-word
bindkey ';5C' forward-word

# User settings
export EDITOR=/bin/nvim
export BROWSER=/bin/chromium
export ANDROID_HOME=/opt/android-sdk
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
alias vim="nvim"
alias android-emulator="/opt/android-sdk/emulator/emulator"
alias android-monitor="/opt/android-sdk/tools/monitor"
alias cookie="fortune -s | cowsay -f tux | lolcat"
alias trizen="trizen --noedit"

