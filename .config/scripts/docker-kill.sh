#!/bin/zsh

SELECTED=$(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}' \
  | fzf --multi \
  --header $'ID\t\t\tIMAGE\t\t\t\tNAME\t\tSTATUS' \
  --preview 'docker stats --no-stream {1}' \
  --preview-window=bottom:3 \
  | awk '{print $1}')

if [ -z "$SELECTED" ]; then
  echo "No container selected."
  exit 0
fi

echo "$SELECTED" | while read -r id; do
docker stop "$id" && echo "Stopped: $id" || echo "Failed to stop: $id"
done
