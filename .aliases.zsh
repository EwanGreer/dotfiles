alias c='clear'
alias ls="eza --color=always --long --git --icons=always --no-time --no-user --show-symlinks --inode"
alias cat='bat'

alias lg="lazygit"
alias lzd='lazydocker'

alias vim='nvim'
alias v='nvim'
alias f='~/.config/scripts/find-file.sh'

alias dcu='docker compose up -d'
alias dcub='docker compose up --build -d'
alias dcd='docker compose down'
alias dps='~/.config/scripts/docker-ps.sh'
alias dk=docker_kill_fzf
alias clearDocker='docker rm $(docker ps -aq); docker rmi $(docker images -q); docker volume rm $(docker volume ls -q);'

docker_kill_fzf() {
  docker kill $(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}' | fzf | awk '{print $1}')
}

alias tls='~/.config/scripts/tmux-ls.sh'

alias myissues='jira issue list -a$(jira me) -s~Done'

alias '?'='ollama run deepseek-r1:14b'

alias awsps='export AWS_PROFILE=$(dp awsso li profiles | fzf)'
alias mr='mise run'

# git alias
alias gp='git pull'
alias gf='git fetch'
alias gP='git push'
alias gc='git commit -m'
alias gac='git add . && git commit -m'
alias gm='git merge main'

alias t='task'
alias tu='taskwarrior-tui'
