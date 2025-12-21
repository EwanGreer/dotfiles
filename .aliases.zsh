alias c='clear'
alias ls="eza --color=always --long --git --icons=always --no-time --show-symlinks --inode"
alias cat='bat'
alias quote='~/.config/scripts/quote.sh'

# --------------------
# Lazy Tools
# --------------------

alias lg="lazygit"
alias lzd='lazydocker'

# --------------------
# Vim
# --------------------

alias f='~/.config/scripts/find-file.sh'

# --------------------
# Docker
# --------------------

alias dcu='docker compose up -d'
alias dcub='docker compose up --build -d'
alias dcd='docker compose down'
alias dps='~/.config/scripts/docker-ps.sh'
alias dk='~/.config/scripts/docker-kill.sh'

alias clearDocker='docker rm $(docker ps -aq); docker rmi $(docker images -q); docker volume rm $(docker volume ls -q);'

# --------------------
# Tmux
# --------------------

alias tls='~/.config/scripts/tmux-ls.sh'

# --------------------
# AI
# --------------------

alias '?'='ollama run deepseek-r1:14b'

# --------------------
# AWS
# --------------------

# --------------------
# Mise
# --------------------

alias mr='mise run'

# --------------------
# Git
# --------------------

alias g-cc='~/.config/scripts/git-cc.sh'
alias g-pr="gh pr list | cut -f1,2 | gum choose | cut -f1 | xargs gh pr checkout"

# --------------------
# Taskwarrior
# --------------------

alias t='task'
alias tu='taskwarrior-tui'

# --------------------
# Terraform
# --------------------

alias tf="terraform"
