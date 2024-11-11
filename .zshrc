if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
HOMEBREW_NO_ENV_HINTS=true

[[ ! -f ~/.secrets ]] || source ~/.secrets
[[ ! -f ~/.plugins.zsh ]] || source ~/.plugins.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(minikube -p minikube docker-env)"

source <(fzf --zsh)

[[ ! -f ~/.aliases.zsh ]] || source ~/.aliases.zsh

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
export GOARCH=amd64
export CGO_ENABLED=1
unset GOPROXY && unset GOSUMDB

bindkey "ç" fzf-cd-widget
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--reverse --preview="bat --style=numbers --color=always --line-range=:500 {}"'
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ACT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500; fi" 

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in 
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

export TERM="xterm-256color"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

export PATH="$PATH:$HOME/.rvm/bin"

fastfetch
