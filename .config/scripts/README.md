# README

## docker-ps.sh

This script uses `fzf-tmux` to search through running docker containers.
Once a container is selected some common options are presented and can be selected with the number keys.

## tmux-ls.sh

This script uses `fzf-tmux` to list running tmux sessions.
Once a session is selected several common actions are presented, and can be selected with the number keys.

## find-file.sh

This script uses `fzf-tmux` to find a file on the host operating system.
`.git` directories are excluded, while other "hidden" files are shown. The selected file is then opened with the `EDITOR` environment variable.
