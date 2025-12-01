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

function awsps() {
  # 1. Capture the profile first
  # We use the full command 'granted' if 'dp' is an alias
  local profile
  profile=$(dp awsso list profiles | fzf)

  # 2. Check if the user actually picked something (didn't press Esc)
  if [ -n "$profile" ]; then
    export AWS_PROFILE="$profile"
    echo "✅ AWS_PROFILE set to: $profile"
  else
    echo "❌ Usage cancelled"
  fi
}

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
