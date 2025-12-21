function cached_eval() {
    local cache_file="$1"
    local cmd="$2"
    
    if [[ ! -f "$cache_file" ]]; then
        mkdir -p "$(dirname "$cache_file")"
        eval "$cmd" > "$cache_file"
    fi
    source "$cache_file"
}

alias regen='rm -rf ~/.cache/zsh && exec zsh'

[[ ! -f ~/.secrets.zsh ]] || source ~/.secrets.zsh
[[ ! -f ~/.plugins.zsh ]] || source ~/.plugins.zsh
[[ ! -f ~/.aliases.zsh ]] || source ~/.aliases.zsh
[[ ! -f ~/.local.zsh ]] || source ~/.local.zsh

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "ç" fzf-cd-widget

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

if [[ "$(uname)" == "Darwin" ]]; then
    cached_eval ~/.cache/zsh/brew.zsh '/opt/homebrew/bin/brew shellenv'
elif [[ "$(uname)" == "Linux" ]]; then
    cached_eval ~/.cache/zsh/brew.zsh '/home/linuxbrew/.linuxbrew/bin/brew shellenv'
fi
export HOMEBREW_NO_ENV_HINTS=true

cached_eval ~/.cache/zsh/mise.zsh '$HOME/.local/bin/mise activate zsh'

cached_eval ~/.cache/zsh/zoxide.zsh 'zoxide init zsh --cmd cd'

cached_eval ~/.cache/zsh/oh-my-posh.zsh \
    'oh-my-posh init zsh --config $HOME/.config/ohmyposh/catpuccin.toml'

if [[ ! "$PATH" == */.fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi
cached_eval ~/.cache/zsh/fzf.zsh 'fzf --zsh'

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#353b45,bg:#282c34,spinner:#56b6c2,hl:#61afef --color=fg:#565c64,header:#61afef,info:#e5c07b,pointer:#56b6c2 --color=marker:#56b6c2,fg+:#b6bdca,prompt:#e5c07b,hl+:#61afef"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--tmux --preview '$show_file_or_dir_preview'"
export FZF_TMUX_OPTS='-p 80%,60% --layout=reverse-list'
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

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

export TERM="xterm-256color"
export EDITOR="nvim"
export PATH="$PATH:$HOME/go/bin"
export GOPRIVATE=github.com/dailypay
export GONOSUMDB=github.com/dailypay/*
unset GOPROXY && unset GOSUMDB


function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}