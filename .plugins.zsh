ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit ice blockf
zinit light zsh-users/zsh-completions

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit wait lucid for \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab \
    MichaelAquilina/zsh-you-should-use

zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zsh-users/zsh-syntax-highlighting

zinit wait lucid for \
    OMZP::git \
    OMZP::sudo \
    OMZP::command-not-found

zinit wait lucid has"kubectl" for \
    OMZP::kubectl \
    OMZP::kubectx

zinit wait lucid has"aws" for \
    OMZP::aws

zinit wait lucid has"docker" for \
    OMZP::docker-compose