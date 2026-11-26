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
if (( $+commands[powerline-daemon] )); then
  # Starting the daemon costs ~200ms of Python even when it's already up
  pgrep -u $UID -f powerline-daemon >/dev/null || powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  # powerline.zsh otherwise runs powerline-config (Python, ~250ms each)
  # three times per shell to ask questions with fixed answers: which
  # client to use, and whether zsh uses the prompt and tmux bindings
  # (yes to both). Rerun those if the powerline config changes.
  POWERLINE_COMMAND=powerline
  POWERLINE_CONFIG_COMMAND=true
  # Glob instead of asking python, which costs a process per shell
  source /usr/lib/python3*/site-packages/powerline/bindings/zsh/powerline.zsh(N[-1])
  POWERLINE_CONFIG_COMMAND=powerline-config
fi

# Short delay to change mode after hitting Esc key
export KEYTIMEOUT=1

# Up/down arrow keys filter history by typed prefix
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search
bindkey -M vicmd "^[[A" up-line-or-beginning-search
bindkey -M vicmd "^[[B" down-line-or-beginning-search

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
# --no-use skips resolving the default alias (~800ms); put the newest
# installed node on PATH directly instead. `nvm use` still works.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
_nvm_node=($NVM_DIR/versions/node/*(N/nOn[1]))
(( $#_nvm_node )) && export PATH=$_nvm_node/bin:$PATH
unset _nvm_node
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

