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
setopt hist_ignore_dups
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# Import/refresh colorscheme from 'wal'
(cat ~/.cache/wal/sequences &)

# Use Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  PYTHON_SITE=$(python -c "import site; print(site.getsitepackages())" | sed "s/[][']//g")
  source $PYTHON_SITE/powerline/bindings/zsh/powerline.zsh
fi

# Short delay to change mode after hitting Esc key
export KEYTIMEOUT=1

# Settings via .Xresources
export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
bindkey ';5D' backward-word
bindkey ';5C' forward-word

# fzf keybindings and completions
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# User settings
export EDITOR=/bin/nvim
export BROWSER=/bin/firefox
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g "" -u'
export FZF_DEFAULT_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200' --bind=tab:up,btab:down"
alias vim='nvim'
alias cookie='fortune -s | cowsay -f tux | lolcat'
alias syu='curl -s https://www.archlinux.org/feeds/news/ | xmllint --xpath //item/title\ \|\ //item/pubDate /dev/stdin | sed -r -e "s:<title>([^<]*?)</title><pubDate>([^<]*?)</pubDate>:\2\t\1\n:g" && yay -Syu'

# Add pip to PATH
export PATH=/home/dave/.local/bin:$PATH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

