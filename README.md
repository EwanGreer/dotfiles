# dotfiles

## Setup

```sh
git clone https://github.com/EwanGreer/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

Install [stow](https://www.gnu.org/software/stow/) if not already present:

```sh
brew install stow
```

Then symlink everything into `$HOME`:

```sh
stow .
```

Create `~/.secrets.zsh` for any config you don't want committed (tokens, private env vars, etc.) — it's sourced automatically but gitignored.

Tools are managed by [mise](https://mise.jdx.dev). After symlinking, run:

```sh
mise install
```

## Neovim

Two configs exist side by side:

- **`nvim`** — LazyVim-based daily driver (`~/.config/nvim`)
- **`nvim-ks`** — kickstart-nvim migration target using native `vim.pack` (`~/.config/kickstart-nvim`, requires Neovim >= 0.12)

Switch with `nvim` (default) or `nvim-ks` (alias defined in `.aliases.zsh`).

## Dependencies

Not managed by mise — install these first:

- [brew](https://brew.sh)
- [mise](https://mise.jdx.dev)
- [oh-my-posh](https://ohmyposh.dev)
- [ollama](https://ollama.com) — pull `deepseek-r1:14b` for the `?` alias
- fortune + cowsay — for the `quote` alias
- [taskwarrior](https://taskwarrior.org) — for the `t`/`tadd` aliases
