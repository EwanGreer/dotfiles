#!/bin/bash

ADD="Add"
RESET="Reset"

ACTION=$(gum choose "$ADD" "$RESET")

if [ "$ACTION" == "$ADD" ]; then
  git status --short | cut -c 4- | sed 's/.* -> //' | gum choose --no-limit | xargs -d '\n' git add --
else
  git status --short | cut -c 4- | sed 's/.* -> //' | gum choose --no-limit | xargs -d '\n' git restore --staged --
fi
