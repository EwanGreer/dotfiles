#!/bin/bash

# Ensure gum is available
if ! command -v gum &>/dev/null; then
  echo "Error: gum is not installed."
  exit 1
fi

# A simple header to let you know the loop is active
echo "⚡ Taskwarrior Fast-Add Mode"
echo "(Leave description blank or press Ctrl+C to exit)"
echo "-----------------------------------------------"

while true; do
  # 1. Description - The 'Exit' trigger
  DESCRIPTION=$(gum input --placeholder "What's the task?")

  # If the user hits Enter without typing or hits Esc/Ctrl+C
  if [ -z "$DESCRIPTION" ]; then
    echo "Exiting..."
    break
  fi

  # 2. Compact Metadata
  # --height 5 keeps the list small and inline
  PRIORITY=$(gum choose "H" "M" "L" "none" --height 5 --header "Priority")
  PROJECT=$(gum input --placeholder "Project (optional)")
  TAG_INPUT=$(gum input --placeholder "Tags (optional)")

  # 3. Process Command
  ARGS=("add" "$DESCRIPTION")
  [ "$PRIORITY" != "none" ] && ARGS+=("priority:$PRIORITY")
  [ -n "$PROJECT" ] && ARGS+=("project:$PROJECT")

  if [ -n "$TAG_INPUT" ]; then
    for tag in ${TAG_INPUT//,/ }; do
      ARGS+=("+$tag")
    done
  fi

  # 4. Execute
  # We show the result briefly then loop back
  if task "${ARGS[@]}" >/dev/null; then
    echo "✓ $DESCRIPTION"
    echo "-----------------------------------------------"
  else
    echo "X Failed to add task."
  fi
done
