#!/bin/bash

# =============================================================================
# WSL SPECIFIC POST-SETUP SCRIPT
# =============================================================================
# Author: Nguyen DB
# Description: Additional WSL-specific configurations and helpers
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# Setup WSL-specific aliases
setup_wsl_aliases() {
    log_section "SETTING UP WSL-SPECIFIC ALIASES"
    
    local wsl_aliases_file="$HOME/.wsl_aliases.zsh"
    
    cat > "$wsl_aliases_file" << 'EOF'
# WSL-specific aliases and functions

# Service management shortcuts
alias start-mysql="sudo service mysql start"
alias stop-mysql="sudo service mysql stop"
alias restart-mysql="sudo service mysql restart"
alias status-mysql="sudo service mysql status"

alias start-postgres="sudo service postgresql start"
alias stop-postgres="sudo service postgresql stop"
alias restart-postgres="sudo service postgresql restart"
alias status-postgres="sudo service postgresql status"

alias start-redis="sudo service redis-server start"
alias stop-redis="sudo service redis-server stop"
alias restart-redis="sudo service redis-server restart"
alias status-redis="sudo service redis-server status"

# Start all development services
start-all-services() {
    echo "Starting all development services..."
    start-mysql
    start-postgres
    start-redis
    echo "All services started!"
}

# Stop all development services
stop-all-services() {
    echo "Stopping all development services..."
    stop-mysql
    stop-postgres
    stop-redis
    echo "All services stopped!"
}

# Check status of all services
status-all-services() {
    echo "Checking status of all services..."
    echo "MySQL:"
    status-mysql
    echo -e "\nPostgreSQL:"
    status-postgres
    echo -e "\nRedis:"
    status-redis
}

# Windows integration
alias explorer="explorer.exe"
alias notepad="notepad.exe"
alias code-win="code.exe"

# Network utilities for WSL
alias wsl-ip="hostname -I | awk '{print \$1}'"
alias windows-ip="cat /etc/resolv.conf | grep nameserver | awk '{print \$2}'"

# Docker utilities for WSL
alias docker-check="docker version && docker-compose version"
alias docker-clean="docker system prune -af"

# Git utilities
alias git-config-wsl="git config --global core.autocrlf true && git config --global core.filemode false"
EOF

    # Add to .zshrc if not already there
    if ! grep -q ".wsl_aliases.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# WSL-specific aliases" >> "$HOME/.zshrc"
        echo "source ~/.wsl_aliases.zsh" >> "$HOME/.zshrc"
    fi
    
    log_success "WSL aliases configured successfully"
}

# Create WSL startup script for services
create_wsl_startup_script() {
    log_section "CREATING WSL STARTUP SCRIPT"
    
    local startup_script="$HOME/start-dev-services.sh"
    
    cat > "$startup_script" << 'EOF'
#!/bin/bash

# WSL Development Services Startup Script
# Run this script to start all development services

echo "🚀 Starting WSL development environment..."

# Start MySQL
echo "Starting MySQL..."
sudo service mysql start

# Start PostgreSQL
echo "Starting PostgreSQL..."
sudo service postgresql start

# Start Redis
echo "Starting Redis..."
sudo service redis-server start

echo "✅ All development services started!"
echo ""
echo "Service status:"
echo "MySQL: $(sudo service mysql status | grep Active | awk '{print $2}')"
echo "PostgreSQL: $(sudo service postgresql status | grep Active | awk '{print $2}')"
echo "Redis: $(sudo service redis-server status | grep Active | awk '{print $2}')"
echo ""
echo "💡 Tips:"
echo "- Use 'status-all-services' to check service status"
echo "- Use 'stop-all-services' to stop all services"
echo "- Services don't auto-start in WSL, run this script when needed"
EOF

    chmod +x "$startup_script"
    
    log_success "WSL startup script created at: $startup_script"
}

# Setup Windows integration helpers
setup_windows_integration() {
    log_section "SETTING UP WINDOWS INTEGRATION"
    
    # Create helper script for opening files in Windows apps
    local windows_helpers="$HOME/.windows_helpers.zsh"
    
    cat > "$windows_helpers" << 'EOF'
# Windows integration helpers

# Open current directory in Windows Explorer
open-explorer() {
    explorer.exe "$(wslpath -w "$(pwd)")"
}

# Open file/directory in Windows File Explorer
open-in-explorer() {
    if [ -z "$1" ]; then
        open-explorer
    else
        explorer.exe "$(wslpath -w "$1")"
    fi
}

# Open VS Code in Windows for current directory
code-windows() {
    if [ -z "$1" ]; then
        code.exe "$(wslpath -w "$(pwd)")"
    else
        code.exe "$(wslpath -w "$1")"
    fi
}

# Convert WSL path to Windows path
to-windows-path() {
    wslpath -w "$1"
}

# Convert Windows path to WSL path
to-wsl-path() {
    wslpath "$1"
}

# Quick access to Windows drives
alias cd-c="cd /mnt/c"
alias cd-d="cd /mnt/d"
alias cd-desktop="cd /mnt/c/Users/\$USER/Desktop"
alias cd-downloads="cd /mnt/c/Users/\$USER/Downloads"
alias cd-documents="cd /mnt/c/Users/\$USER/Documents"
EOF

    # Add to .zshrc if not already there
    if ! grep -q ".windows_helpers.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Windows integration helpers" >> "$HOME/.zshrc"
        echo "source ~/.windows_helpers.zsh" >> "$HOME/.zshrc"
    fi
    
    log_success "Windows integration helpers configured"
}

# Create development environment info script
create_dev_info_script() {
    log_section "CREATING DEVELOPMENT INFO SCRIPT"
    
    local dev_info_script="$HOME/dev-info.sh"
    
    cat > "$dev_info_script" << 'EOF'
#!/bin/bash

# Development Environment Information Script

echo "🖥️  WSL Development Environment Information"
echo "=========================================="
echo ""

echo "📍 System Information:"
echo "WSL Version: $(wsl.exe --version 2>/dev/null | head -1 || echo 'WSL 1')"
echo "Distribution: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "WSL IP: $(hostname -I | awk '{print $1}')"
echo "Windows IP: $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')"
echo ""

echo "🛠️  Development Tools:"
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "npm: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
echo "pip: $(pip3 --version 2>/dev/null | awk '{print $2}' || echo 'Not installed')"
echo "Git: $(git --version 2>/dev/null || echo 'Not installed')"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo "Docker Compose: $(docker-compose --version 2>/dev/null || echo 'Not installed')"
echo ""

echo "🗄️  Database Services:"
echo "MySQL: $(sudo service mysql status 2>/dev/null | grep Active | awk '{print $2}' || echo 'Not running')"
echo "PostgreSQL: $(sudo service postgresql status 2>/dev/null | grep Active | awk '{print $2}' || echo 'Not running')"
echo "Redis: $(sudo service redis-server status 2>/dev/null | grep Active | awk '{print $2}' || echo 'Not running')"
echo ""

echo "📁 Development Directories:"
echo "Home: $HOME"
echo "Current: $(pwd)"
echo "Projects: $HOME/Projects ($([ -d "$HOME/Projects" ] && echo 'exists' || echo 'not created'))"
echo ""

echo "💡 Useful Commands:"
echo "start-all-services  - Start all development services"
echo "stop-all-services   - Stop all development services"
echo "status-all-services - Check status of all services"
echo "dev-info           - Show this information"
echo "open-explorer      - Open current directory in Windows Explorer"
echo "code-windows       - Open current directory in VS Code (Windows)"
EOF

    chmod +x "$dev_info_script"
    
    # Create alias for easy access
    echo "" >> "$HOME/.zshrc"
    echo "# Development environment info" >> "$HOME/.zshrc"
    echo "alias dev-info='$dev_info_script'" >> "$HOME/.zshrc"
    
    log_success "Development info script created at: $dev_info_script"
}

# Main execution
main() {
    log_section "WSL POST-SETUP CONFIGURATION"
    log_info "Configuring WSL-specific enhancements..."
    
    setup_wsl_aliases
    create_wsl_startup_script
    setup_windows_integration
    create_dev_info_script
    
    log_section "WSL POST-SETUP COMPLETED!"
    echo -e "${GREEN}"
    echo "🎉 WSL-specific configuration completed!"
    echo ""
    echo "📋 What was configured:"
    echo "  ✅ WSL-specific aliases for service management"
    echo "  ✅ Windows integration helpers"
    echo "  ✅ Development services startup script"
    echo "  ✅ Development environment info script"
    echo ""
    echo "🔄 Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Run 'dev-info' to see your environment status"
    echo "  3. Use 'start-all-services' to start development services"
    echo "  4. Use 'open-explorer' to open current directory in Windows"
    echo ""
    echo "📚 New commands available:"
    echo "  - start-all-services / stop-all-services"
    echo "  - status-all-services"
    echo "  - open-explorer / code-windows"
    echo "  - dev-info"
    echo "  - Various service shortcuts (start-mysql, start-postgres, etc.)"
    echo -e "${NC}"
}

# Check if running in WSL
if ! [[ -f /proc/version ]] || ! grep -qi "microsoft\|wsl" /proc/version; then
    log_error "This script is designed for WSL environments only"
    exit 1
fi

# Run main function
main "$@"
