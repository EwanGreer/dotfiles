#!/bin/zsh

function g-cc() {
  prefix=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
  scope=$(gum input --placeholder "scope")
  message=$(gum input --placeholder "message")
  description=$(gum input --placeholder "description")

  git commit -m "${prefix}(${scope}): ${message}" -m "${description}"
}

g-cc
