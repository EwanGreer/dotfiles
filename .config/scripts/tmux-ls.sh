#!/bin/zsh

if ! command -v tmux &>/dev/null; then
  echo "Error: tmux is not installed."
  exit 1
fi

if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is not installed."
  exit 1
fi

browse_tmux_sessions() {
  local sessions
  sessions=$(tmux ls 2>/dev/null)

  if [[ -z "$sessions" ]]; then
    echo "No tmux sessions found."
    return 1
  fi

  local selected
  selected=$(echo "$sessions" | fzf --header "Select a tmux session" --border --height=50% --no-preview)
  
  if [[ $? -ne 0 ]]; then
    echo "Session selection cancelled."
    return 1
  fi

  if [[ -n "$selected" ]]; then
    local session_name="${selected%%:*}"
    tmux attach-session -t "$session_name"
  else
    echo "No session selected."
  fi
}

browse_tmux_sessions
