function cached_eval() {
    local cache_file="$1"
    local cmd="$2"

    if [[ ! -f "$cache_file" ]]; then
        mkdir -p "$(dirname "$cache_file")"
        eval "$cmd" > "$cache_file" || rm -f "$cache_file"
    fi
    source "$cache_file"
}

alias regen='rm -rf ~/.cache/zsh && exec zsh'

typeset -U path
export PATH="$HOME/.local/bin:$PATH"

export NVIM_APPNAME="kickstart-nvim"
export EDITOR="nvim"
export VISUAL="nvim"

[[ ! -f ~/.secrets.zsh ]] || source ~/.secrets.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always "$realpath"'

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
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

local _os="$(uname)"
if [[ "$_os" == "Darwin" ]]; then
    cached_eval ~/.cache/zsh/brew.zsh '/opt/homebrew/bin/brew shellenv'
elif [[ "$_os" == "Linux" ]]; then
    cached_eval ~/.cache/zsh/brew.zsh '/home/linuxbrew/.linuxbrew/bin/brew shellenv'
fi
cached_eval ~/.cache/zsh/mise.zsh '$HOME/.local/bin/mise activate zsh'
cached_eval ~/.cache/zsh/mise-completions.zsh '$HOME/.local/bin/mise completion zsh'

cached_eval ~/.cache/zsh/zoxide.zsh 'zoxide init zsh --cmd cd'

cached_eval ~/.cache/zsh/oh-my-posh.zsh \
    'oh-my-posh init zsh --config $HOME/.config/ohmyposh/catppuccin.toml'

cached_eval ~/.cache/zsh/fzf.zsh 'fzf --zsh'

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#353b45,bg:#282c34,spinner:#56b6c2,hl:#61afef --color=fg:#565c64,header:#61afef,info:#e5c07b,pointer:#56b6c2 --color=marker:#56b6c2,fg+:#b6bdca,prompt:#e5c07b,hl+:#61afef"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--tmux --preview '$show_file_or_dir_preview'"
export FZF_CTRL_R_OPTS="--height=100%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf-tmux --preview "eval 'echo \${}'" "$@" ;;
        ssh) fzf --preview 'dig {}' "$@" ;;
        *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}
