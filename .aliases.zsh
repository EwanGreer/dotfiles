alias c='clear'
alias ls="eza --color=always --long --git --icons=always --no-time --no-user --show-symlinks --inode"
alias cat='bat'

alias y='~/.config/scripts/yazi.sh'

alias lg="lazygit"
alias lzd='lazydocker'

alias vim='nvim'
alias v='nvim'
alias f='~/.config/scripts/find-file.sh'
export EDITOR='nvim'

alias dcu='docker compose up -d'
alias dcub='docker compose up --build -d'
alias dcd='docker compose down'
alias dps='~/.config/scripts/docker-ps.sh'
alias dk=docker_kill_fzf

docker_kill_fzf() {
  docker kill $(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}' | fzf | awk '{print $1}')
}

alias tls='~/.config/scripts/tmux-ls.sh'

alias myissues='jira issue list -a$(jira me) -s~Done'
