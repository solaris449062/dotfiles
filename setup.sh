#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
ZSHRC_SOURCE="$DOTFILES_DIR/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
VIMRC_SOURCE="$DOTFILES_DIR/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"
WEZTERM_SOURCE="$DOTFILES_DIR/.wezterm.lua"
WEZTERM_TARGET="$HOME/.wezterm.lua"
TMUX_SOURCE="$DOTFILES_DIR/.tmux.conf"
TMUX_TARGET="$HOME/.tmux.conf"
STARSHIP_INIT='eval "$(starship init zsh)"'
AGENTS_SOURCE="$DOTFILES_DIR/AGENTS.md"
CODEX_AGENTS_TARGET="$HOME/.codex/AGENTS.md"
CLAUDE_TARGET="$HOME/.claude/CLAUDE.md"
COPILOT_TARGET="$HOME/.copilot/copilot-instructions.md"

link_dotfile() {
  local source="$1"
  local target="$2"
  local backup

  if [[ ! -f "$source" ]]; then
    print -u2 "Dotfile not found: $source"
    exit 1
  fi

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    print "Already linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup="${target}.backup.$(date '+%Y%m%d%H%M%S')"
    mv "$target" "$backup"
    print "Backed up $target to $backup"
  fi

  ln -s "$source" "$target"
  print "Linked $target -> $source"
}

append_line_once() {
  local file="$1"
  local line="$2"

  if ! grep -Fqx -- "$line" "$file"; then
    print >> "$file"
    print "$line" >> "$file"
    print "Added line to $file"
  fi
}

link_optional_agent_instruction() {
  local source="$1"
  local target="$2"
  local parent

  parent="$(dirname "$target")"
  if [[ ! -d "$parent" ]]; then
    print "Skipping optional agent instructions: $parent does not exist"
    return
  fi

  link_dotfile "$source" "$target"
}

# Install Homebrew first if needed: https://brew.sh/
print "Installing Homebrew packages..."
brew install git gh herdr neovim tmux starship
brew install --cask visual-studio-code wezterm

print "Linking dotfiles..."
link_dotfile "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
link_dotfile "$VIMRC_SOURCE" "$VIMRC_TARGET"
link_dotfile "$WEZTERM_SOURCE" "$WEZTERM_TARGET"
link_dotfile "$TMUX_SOURCE" "$TMUX_TARGET"

append_line_once "$ZSHRC_SOURCE" "$STARSHIP_INIT"

print "Linking global agent instructions..."
mkdir -p "$HOME/.codex"
link_dotfile "$AGENTS_SOURCE" "$CODEX_AGENTS_TARGET"
link_optional_agent_instruction "$AGENTS_SOURCE" "$CLAUDE_TARGET"
link_optional_agent_instruction "$AGENTS_SOURCE" "$COPILOT_TARGET"

print "Setup complete. Open a new terminal or run:"
print "  source ~/.zshrc"
