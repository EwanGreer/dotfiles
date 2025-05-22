#!/bin/zsh

for cmd in docker fzf-tmux sed awk; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is not installed." >&2
    exit 1
  fi
done

browse_containers() {
  local containers
  containers=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}" | sed '1d')

  if [[ -z "$containers" ]]; then
    echo "No running containers found."
    return 1
  fi

  local selected
  selected=$(echo "$containers" | fzf-tmux -p --header "Select a container (ID, Name, Status, Ports, Image)" --border --height=50% --no-preview)

  if [[ -z "$selected" ]]; then
    echo "No container selected."
    return 1
  fi

  local container_id
  container_id=$(echo "$selected" | awk '{print $1}')

  local actions
  actions=$(
    cat <<EOF
    1) Logs
    2) Inspect
    3) Shell (exec)
    4) Stop
    5) Remove
EOF
  )

  local action
  action=$(echo "$actions" | fzf-tmux -p --header "Select an action for container $container_id" --border --height=30% --no-preview)

  if [[ -z "$action" ]]; then
    echo "No action selected."
    return 1
  fi

  action=$(echo "$action" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/\r$//')
  case "$action" in
  "1)"* | "1) Logs")
    docker logs -f "$container_id"
    ;;
  "2)"* | "2) Inspect")
    docker inspect "$container_id" | less
    ;;
  "3)"* | "3) Shell (exec)")
    docker exec -it "$container_id" /bin/sh || docker exec -it "$container_id" /bin/bash
    ;;
  "4)"* | "4) Stop")
    docker stop "$container_id"
    ;;
  "5)"* | "5) Remove")
    docker rm -f "$container_id"
    ;;
  *)
    echo "Invalid action selected."
    ;;
  esac
}

browse_containers
