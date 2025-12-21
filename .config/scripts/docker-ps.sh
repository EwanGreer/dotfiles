#!/bin/zsh

# 1. Dependency Check
for cmd in docker fzf awk; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is not installed." >&2
    exit 1
  fi
done

browse_containers() {
  while true; do
    # 2. Get Containers
    # We use Docker's native "table" format to handle alignment automatically.
    # This works on both macOS and Linux without needing 'column'.
    local containers
    containers=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}")

    # Check if we have more than just the header line
    if [[ $(echo "$containers" | wc -l) -lt 2 ]]; then
      echo "No running containers found."
      return 0
    fi

    # 3. Select Container
    # --header-lines=1 tells fzf to treat the first line (ID, NAMES...) as a sticky header
    local selected
    selected=$(echo "$containers" | fzf --header-lines=1 \
                                        --layout=reverse \
                                        --border \
                                        --height=40% \
                                        --prompt="Select Container > ")

    if [[ -z "$selected" ]]; then
      echo "No container selected. Exiting."
      return 0
    fi

    local container_id
    container_id=$(echo "$selected" | awk '{print $1}')

    # 4. Action Menu
    local actions
    actions=$(cat <<-EOF
		1) Logs
		2) Inspect
		3) Shell (Bash)
		4) Shell (Sh)
		5) Stop
		6) Restart
		7) Remove
	EOF
    )

    local action
    action=$(echo "$actions" | fzf --layout=reverse --border --height=30% --prompt="Action for $container_id > ")

    if [[ -z "$action" ]]; then
      continue # Loop back to list if they hit Esc
    fi

    # 5. Execute Action
    case "$action" in
      "1) Logs")
        # Clear screen for cleaner logs
        clear
        docker logs -f "$container_id"
        ;;
      "2) Inspect")
        docker inspect "$container_id" | less
        ;;
      "3) Shell (Bash)")
        docker exec -it "$container_id" /bin/bash
        ;;
      "4) Shell (Sh)")
        docker exec -it "$container_id" /bin/sh
        ;;
      "5) Stop")
        docker stop "$container_id"
        ;;
      "6) Restart")
        docker restart "$container_id"
        ;;
      "7) Remove")
        docker rm -f "$container_id"
        ;;
    esac
    
    # Pause briefly if not entering an interactive mode (like logs/shell)
    if [[ "$action" != "1)"* && "$action" != "3)"* && "$action" != "4)"* ]]; then
        echo "Action completed. Press Enter..."
        read
    fi
  done
}

browse_containers
