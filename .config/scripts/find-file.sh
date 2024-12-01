#!/bin/zsh

vf() {
  local file
  file=$(fd --hidden --type f --type d --exclude .git 2>/dev/null | fzf-tmux -p 80%,60% --preview '[[ -f {} ]] && bat --style=numbers --color=always --line-range=:500 {} || ls -la {}')

  if [[ -n "$file" ]]; then
    if [[ -f "$file" ]]; then
      nvim "$file"
    else
      ls -la "$file"
    fi
  fi
}

vf
