#!/bin/zsh

SELECTED_CONTAINER=$(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}' | fzf | awk '{print $1}')
if [ -n "$SELECTED_CONTAINER" ]; then
  docker kill "$SELECTED_CONTAINER"
  echo "Killed container: $SELECTED_CONTAINER"
fi
