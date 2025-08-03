#!/bin/zsh

for cmd in fd fzf-tmux bat nvim gum; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is not installed." >&2
    exit 1
  fi
done

vf() {
  local file
  file=$(fd --hidden --type f --type d --exclude .git 2>/dev/null | \
         fzf-tmux -p 80%,60% --preview '[[ -f {} ]] && bat --style=numbers --color=always --line-range=:500 {} || ls -la {}')
  
  [[ -z "$file" ]] && return

  if [[ -f "$file" ]]; then
    nvim "$file"
  else
    ls -la "$file"
  fi
}

vf
