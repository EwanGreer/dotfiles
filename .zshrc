if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
HOMEBREW_NO_ENV_HINTS=true

[[ ! -f ~/.secrets ]] || source ~/.secrets.zsh
[[ ! -f ~/.plugins.zsh ]] || source ~/.plugins.zsh

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(zoxide init zsh --cmd cd)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source <(fzf --zsh)

[[ ! -f ~/.aliases.zsh ]] || source ~/.aliases.zsh

export PATH="$PATH:$(go env GOPATH)/bin"
export GOPRIVATE=github.com/dailypay
export GONOSUMDB=github.com/dailypay/*
unset GOPROXY && unset GOSUMDB

export PATH=$PATH:/home/shrek/.cargo/bin

bindkey "ç" fzf-cd-widget
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"
export FZF_ALT_R_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--tmux --height=50%'
export FZF_CTRL_T_OPTS="--tmux --preview '$show_file_or_dir_preview'"

export FZF_TMUX_OPTS='-p 80%,60% --layout=reverse-list'
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500; fi" 

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in 
    cd) fzf-tmux --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf-tmux --preview "eval 'echo \${}'" "$@" ;;
    ssh) fzf-tmux --preview 'dig {}' "$@" ;;
    *) fzf-tmux --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# eval $(thefuck --alias)
export TERM="xterm-256color"

export PATH="$PATH:$HOME/.rvm/bin"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/catpuccin.toml)"

fastfetch
