#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
ZSHRC_SOURCE="$DOTFILES_DIR/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
VIMRC_SOURCE="$DOTFILES_DIR/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"
NVIM_SOURCE="$DOTFILES_DIR/nvim"
NVIM_TARGET="$HOME/.config/nvim"
WEZTERM_SOURCE="$DOTFILES_DIR/.wezterm.lua"
WEZTERM_TARGET="$HOME/.wezterm.lua"
TMUX_SOURCE="$DOTFILES_DIR/.tmux.conf"
TMUX_TARGET="$HOME/.tmux.conf"
STARSHIP_INIT='eval "$(starship init zsh)"'
AGENTS_SOURCE="$DOTFILES_DIR/AGENTS.md"
CODEX_AGENTS_TARGET="$HOME/.codex/AGENTS.md"
CLAUDE_TARGET="$HOME/.claude/CLAUDE.md"
COPILOT_TARGET="$HOME/.copilot/copilot-instructions.md"
SDKMAN_DIR="$HOME/.sdkman"
JAVA_VERSION="21.0.12-tem"

link_path() {
  local source="$1"
  local target="$2"
  local backup

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    print -u2 "Path not found: $source"
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

  mkdir -p "$(dirname "$target")"
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

install_sdkman_java() {
  # SDKMAN manages Java so the active JDK is independent of Homebrew.
  if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    print "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
  fi

  # Load SDKMAN into this setup process so the `sdk` command is available now.
  source "$SDKMAN_DIR/bin/sdkman-init.sh"

  # Install the pinned Java version only when this machine does not have it.
  if [[ ! -d "$SDKMAN_DIR/candidates/java/$JAVA_VERSION" ]]; then
    print "Installing Java $JAVA_VERSION through SDKMAN..."
    sdk install java "$JAVA_VERSION" < <(print -r -- "n")
  fi

  # Make the same SDKMAN-managed JDK the default in future shells.
  sdk default java "$JAVA_VERSION"
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

  link_path "$source" "$target"
}

# Install Homebrew first if needed: https://brew.sh/
print "Installing Homebrew packages..."
brew install git gh herdr neovim go tmux starship
brew install --cask visual-studio-code wezterm

print "Setting up Java through SDKMAN..."
install_sdkman_java

print "Linking dotfiles..."
link_path "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
link_path "$VIMRC_SOURCE" "$VIMRC_TARGET"
link_path "$NVIM_SOURCE" "$NVIM_TARGET"
link_path "$WEZTERM_SOURCE" "$WEZTERM_TARGET"
link_path "$TMUX_SOURCE" "$TMUX_TARGET"

append_line_once "$ZSHRC_SOURCE" "$STARSHIP_INIT"

print "Linking global agent instructions..."
mkdir -p "$HOME/.codex"
link_path "$AGENTS_SOURCE" "$CODEX_AGENTS_TARGET"
link_optional_agent_instruction "$AGENTS_SOURCE" "$CLAUDE_TARGET"
link_optional_agent_instruction "$AGENTS_SOURCE" "$COPILOT_TARGET"

print "Setup complete. Open a new terminal or run:"
print "  source ~/.zshrc"
