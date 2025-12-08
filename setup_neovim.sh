#!/bin/bash

# setup_neovim.sh
# Sets up Neovim configuration for macOS and Ubuntu

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

log_info "Detected OS: $MACHINE"

install_package() {
    PACKAGE=$1
    if ! command -v $PACKAGE &> /dev/null; then
        log_info "$PACKAGE not found. Installing..."
        if [ "$MACHINE" == "Mac" ]; then
            brew install $PACKAGE
        elif [ "$MACHINE" == "Linux" ]; then
            sudo apt-get install -y $PACKAGE
        fi
    else
        log_info "$PACKAGE is already installed."
    fi
}

# Install Dependencies
if [ "$MACHINE" == "Mac" ]; then
    if ! command -v brew &> /dev/null; then
        log_warning "Homebrew not found. Skipping package installation."
    else
        install_package neovim
        install_package ripgrep
        install_package fd
    fi
elif [ "$MACHINE" == "Linux" ]; then
    if ! command -v apt-get &> /dev/null; then
        log_warning "apt-get not found. Skipping package installation."
    else
        # Update apt cache only if it's older than a day (optional, but good practice)
        # For now, just update to be safe
        sudo apt-get update
        install_package neovim
        install_package ripgrep
        
        # fd-find is often named fdfind on ubuntu
        if ! command -v fd &> /dev/null && ! command -v fdfind &> /dev/null; then
             sudo apt-get install -y fd-find
        fi
        
        # Symlink fdfind to fd if fd doesn't exist
        if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
             mkdir -p ~/.local/bin
             ln -sf $(which fdfind) ~/.local/bin/fd
             log_info "Symlinked fdfind to ~/.local/bin/fd"
        fi
    fi
fi

# Backup existing config
CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    if [ -L "$CONFIG_DIR" ]; then
        log_info "Removing existing symlink $CONFIG_DIR"
        rm "$CONFIG_DIR"
    else
        BACKUP_DIR="${CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up existing config to $BACKUP_DIR"
        mv "$CONFIG_DIR" "$BACKUP_DIR"
    fi
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Symlink new config
# Ensure we are using absolute path
REPO_ROOT="$(pwd)"
REPO_CONFIG_DIR="$REPO_ROOT/.config/nvim"

if [ ! -d "$REPO_CONFIG_DIR" ]; then
    log_warning "Configuration directory $REPO_CONFIG_DIR not found!"
    exit 1
fi

log_info "Linking $REPO_CONFIG_DIR to $CONFIG_DIR"
ln -s "$REPO_CONFIG_DIR" "$CONFIG_DIR"

log_success "Neovim setup complete!"
