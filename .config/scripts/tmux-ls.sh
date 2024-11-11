#!/bin/zsh

browse_tmux_sessions() {
  # Get the list of tmux sessions
  local sessions=$(tmux ls 2>/dev/null)

  if [[ -z "$sessions" ]]; then
    echo "No tmux sessions found."
    return
  fi

  # Use fzf to select a session
  local selected=$(echo "$sessions" | fzf --header "Select a tmux session" --border --height=50% --no-preview)

  # If a session is selected, display further options
  if [[ -n "$selected" ]]; then
    # Extract the session name (everything before the first colon)
    local session_name=$(echo "$selected" | awk -F: '{print $1}')

    echo "Selected session: $session_name"
    echo "Actions:"
    echo "1) Attach"
    echo "2) Kill"
    echo "3) Rename"
    echo "4) List Windows"
    echo "5) Detach Clients"

    # Get user choice
    read "choice?Choose an action (1-5): "
    case $choice in
    1) tmux attach-session -t "$session_name" ;;
    2) tmux kill-session -t "$session_name" ;;
    3)
      read "new_name?Enter new session name: "
      tmux rename-session -t "$session_name" "$new_name"
      ;;
    4) tmux list-windows -t "$session_name" | less ;;
    5) tmux detach-client -s "$session_name" ;;
    *) echo "Invalid choice" ;;
    esac
  else
    echo "No session selected."
  fi
}

browse_tmux_sessions
