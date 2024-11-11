#!/bin/zsh

browse_containers() {
  # Get the list of running containers, removing the header line
  local containers=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | sed '1d')

  # Use fzf to select a container
  local selected=$(echo "$containers" | fzf --header "Select a container (ID, Name, Status, Image)" --border --height=50% --no-preview)

  # If a container is selected, display further options
  if [[ -n "$selected" ]]; then
    local container_id=$(echo "$selected" | awk '{print $1}')

    echo "Selected container: $container_id"
    echo "Actions:"
    echo "1) Logs"
    echo "2) Inspect"
    echo "3) Shell (exec)"
    echo "4) Stop"
    echo "5) Remove"

    # Get user choice
    read "choice?Choose an action (1-5): "
    case $choice in
    1) docker logs -f $container_id ;;
    2) docker inspect $container_id | less ;;
    3) docker exec -it $container_id /bin/sh || docker exec -it $container_id /bin/bash ;;
    4) docker stop $container_id ;;
    5) docker rm -f $container_id ;;
    *) echo "Invalid choice" ;;
    esac
  fi
}

browse_containers
