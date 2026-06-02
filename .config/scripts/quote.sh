#!/bin/zsh

if ! command -v fortune &>/dev/null || ! command -v cowsay &>/dev/null; then
  echo "Error: fortune and cowsay are required. Install them with your system package manager."
  exit 1
fi

fortune -s | cowsay
