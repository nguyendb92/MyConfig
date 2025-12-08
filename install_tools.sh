#!/bin/bash

# install_tools.sh
# Installs additional development tools for macOS and Ubuntu
# Tools: lazygit, lazydocker, Maccy (macOS only), zoxide, git-delta

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

install_brew_package() {
    PACKAGE=$1
    if ! command -v $PACKAGE &> /dev/null; then
        log_info "Installing $PACKAGE via Homebrew..."
        brew install $PACKAGE
    else
        log_info "$PACKAGE is already installed."
    fi
}

install_brew_cask() {
    PACKAGE=$1
    # Casks are harder to check with command -v, usually check brew list
    if ! brew list --cask $PACKAGE &> /dev/null; then
        log_info "Installing $PACKAGE via Homebrew Cask..."
        brew install --cask $PACKAGE
    else
        log_info "$PACKAGE is already installed."
    fi
}

install_ubuntu_lazygit() {
    if ! command -v lazygit &> /dev/null; then
        log_info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
        log_success "lazygit installed"
    else
        log_info "lazygit is already installed"
    fi
}

install_ubuntu_lazydocker() {
    if ! command -v lazydocker &> /dev/null; then
        log_info "Installing lazydocker..."
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
        log_success "lazydocker installed"
    else
        log_info "lazydocker is already installed"
    fi
}

install_ubuntu_zoxide() {
    if ! command -v zoxide &> /dev/null; then
        log_info "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        log_success "zoxide installed"
        log_warning "Please add 'eval \"\$(zoxide init zsh)\"' to your .zshrc"
    else
        log_info "zoxide is already installed"
    fi
}

install_ubuntu_delta() {
    if ! command -v delta &> /dev/null; then
        log_info "Installing git-delta..."
        # Attempt to find the latest .deb
        DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
        curl -Lo git-delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
        sudo dpkg -i git-delta.deb
        rm git-delta.deb
        log_success "git-delta installed"
    else
        log_info "git-delta is already installed"
    fi
}

if [ "$MACHINE" == "Mac" ]; then
    if ! command -v brew &> /dev/null; then
        log_warning "Homebrew not found. Please install Homebrew first."
        exit 1
    fi

    log_info "Installing tools for macOS..."
    install_brew_package lazygit
    install_brew_package lazydocker
    install_brew_package zoxide
    install_brew_package git-delta
    install_brew_cask maccy

elif [ "$MACHINE" == "Linux" ]; then
    log_info "Installing tools for Ubuntu/Linux..."
    
    # Ensure curl is installed
    if ! command -v curl &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y curl
    fi

    install_ubuntu_lazygit
    install_ubuntu_lazydocker
    install_ubuntu_zoxide
    install_ubuntu_delta
    
    log_info "Note: Maccy is a macOS only application and was skipped."
fi

log_success "Tools installation complete!"
