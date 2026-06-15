#!/bin/zsh
count=$(/opt/homebrew/bin/task count status:pending 2>/dev/null)
if [[ $count -gt 0 ]]; then
  osascript -e "display notification \"You have $count pending task(s)\" with title \"TaskWarrior\" sound name \"default\""
fi
