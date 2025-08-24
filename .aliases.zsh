alias c='clear'
alias ls="eza --color=always --long --git --icons=always --no-time --show-symlinks --inode"
alias cat='bat'

# --------------------
# Lazy Tools
# --------------------

alias lg="lazygit"
alias lzd='lazydocker'

# --------------------
# Vim
# --------------------

alias vim='nvim'
alias v='nvim'
alias f='~/.config/scripts/find-file.sh'

# --------------------
# Docker
# --------------------

alias dcu='docker compose up -d'
alias dcub='docker compose up --build -d'
alias dcd='docker compose down'
alias dps='~/.config/scripts/docker-ps.sh'
alias dk=docker_kill_fzf
alias clearDocker='docker rm $(docker ps -aq); docker rmi $(docker images -q); docker volume rm $(docker volume ls -q);'

docker_kill_fzf() {
  docker kill $(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}' | fzf | awk '{print $1}')
}

# --------------------
# Tmux
# --------------------

alias tls='~/.config/scripts/tmux-ls.sh'

# --------------------
# Jira
# --------------------

alias myissues='jira issue list -a$(jira me) -s~Done'


# --------------------
# AI
# --------------------

alias '?'='ollama run deepseek-r1:14b'

# --------------------
# AWS
# --------------------

alias awsps='export AWS_PROFILE=$(dp awsso li profiles | fzf)'

# --------------------
# Mise
# --------------------

alias mr='mise run'

# --------------------
# Git
# --------------------

alias gp='git pull'
alias gf='git fetch'
alias gP='git push'
alias gc='git commit -m'
alias gac='git add . && git commit -m'
alias gm='git merge main'
alias g-cc='~/.config/scripts/git-cc.sh'
alias g-pr="gh pr list | cut -f1,2 | gum choose | cut -f1 | xargs gh pr checkout"

# --------------------
# Taskwarrior
# --------------------

alias t='task'
alias tu='taskwarrior-tui'

# --------------------
# DP Cli
# --------------------

alias dpk='dp mesh k'

# --------------------
# Terraform
# --------------------

alias tf="terraform"
