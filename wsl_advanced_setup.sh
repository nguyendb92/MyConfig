#!/bin/bash

# =============================================================================
# ENHANCED WSL CONFIGURATION SCRIPT
# =============================================================================
# Author: Nguyen DB
# Description: Advanced WSL-specific setup and configuration
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

# WSL Configuration and Optimization
configure_wsl_settings() {
    log_section "CONFIGURING WSL SETTINGS"
    
    # Create or update .wslconfig file
    local wslconfig="/mnt/c/Users/$(whoami)/.wslconfig"
    if [ ! -f "$wslconfig" ]; then
        log_info "Creating .wslconfig file for better WSL performance..."
        cat > "$wslconfig" << 'EOF'
[wsl2]
# Memory allocation - adjust based on your system
memory=4GB
# CPU allocation 
processors=2
# Swap size
swap=2GB
# Enable localhost forwarding
localhostforwarding=true
# Network mode
networkingMode=mirrored
# DNS tunneling
dnsTunneling=true
# Enable systemd
systemd=true

[experimental]
# Auto memory reclaim
autoMemoryReclaim=gradual
# Sparse VHD
sparseVhd=true
EOF
        log_success ".wslconfig created successfully"
        log_warning "Please restart WSL for changes to take effect: wsl --shutdown"
    else
        log_info ".wslconfig already exists"
    fi
}

# Setup WSL-specific development environment
setup_wsl_development_env() {
    log_section "SETTING UP WSL DEVELOPMENT ENVIRONMENT"
    
    # Create Windows integration aliases
    local wsl_aliases="$HOME/.wsl_dev_aliases.zsh"
    cat > "$wsl_aliases" << 'EOF'
# WSL Development Environment Aliases

# === SERVICE MANAGEMENT ===
alias start-mysql="sudo service mysql start && echo '✅ MySQL started'"
alias stop-mysql="sudo service mysql stop && echo '🛑 MySQL stopped'"
alias restart-mysql="sudo service mysql restart && echo '🔄 MySQL restarted'"
alias status-mysql="sudo service mysql status"

alias start-postgres="sudo service postgresql start && echo '✅ PostgreSQL started'"
alias stop-postgres="sudo service postgresql stop && echo '🛑 PostgreSQL stopped'"
alias restart-postgres="sudo service postgresql restart && echo '🔄 PostgreSQL restarted'"
alias status-postgres="sudo service postgresql status"

alias start-redis="sudo service redis-server start && echo '✅ Redis started'"
alias stop-redis="sudo service redis-server stop && echo '🛑 Redis stopped'"
alias restart-redis="sudo service redis-server restart && echo '🔄 Redis restarted'"
alias status-redis="sudo service redis-server status"

alias start-nginx="sudo service nginx start && echo '✅ Nginx started'"
alias stop-nginx="sudo service nginx stop && echo '🛑 Nginx stopped'"
alias restart-nginx="sudo service nginx restart && echo '🔄 Nginx restarted'"
alias status-nginx="sudo service nginx status"

# Start/Stop all services
start-all-dev-services() {
    echo "🚀 Starting all development services..."
    start-mysql 2>/dev/null || echo "❌ MySQL failed to start"
    start-postgres 2>/dev/null || echo "❌ PostgreSQL failed to start"
    start-redis 2>/dev/null || echo "❌ Redis failed to start"
    start-nginx 2>/dev/null || echo "❌ Nginx failed to start (optional)"
    echo "✅ Service startup completed!"
}

stop-all-dev-services() {
    echo "🛑 Stopping all development services..."
    stop-mysql 2>/dev/null || echo "❌ MySQL failed to stop"
    stop-postgres 2>/dev/null || echo "❌ PostgreSQL failed to stop"
    stop-redis 2>/dev/null || echo "❌ Redis failed to stop"
    stop-nginx 2>/dev/null || echo "❌ Nginx failed to stop (optional)"
    echo "✅ All services stopped!"
}

check-all-services() {
    echo "📊 Checking status of all services..."
    echo ""
    echo "MySQL:"
    status-mysql 2>/dev/null | grep "Active" || echo "❌ Not running"
    echo ""
    echo "PostgreSQL:"
    status-postgres 2>/dev/null | grep "Active" || echo "❌ Not running"
    echo ""
    echo "Redis:"
    status-redis 2>/dev/null | grep "Active" || echo "❌ Not running"
    echo ""
    echo "Docker:"
    docker ps 2>/dev/null >/dev/null && echo "✅ Docker is running" || echo "❌ Docker not available"
}

# === WINDOWS INTEGRATION ===
# Open current directory in Windows Explorer
alias explorer="explorer.exe"
alias open-here="explorer.exe ."
alias open-explorer="explorer.exe \$(wslpath -w \$(pwd))"

# Open in Windows applications
open-in-notepad() {
    notepad.exe "$(wslpath -w "$1")"
}

open-in-vscode-windows() {
    if [ -z "$1" ]; then
        code.exe "$(wslpath -w "$(pwd)")"
    else
        code.exe "$(wslpath -w "$1")"
    fi
}

# Path conversion utilities
to-windows-path() {
    wslpath -w "$1"
}

to-wsl-path() {
    wslpath "$1"
}

# Quick access to Windows directories
alias cd-windows="cd /mnt/c"
alias cd-users="cd /mnt/c/Users"
alias cd-desktop="cd /mnt/c/Users/\$(whoami)/Desktop"
alias cd-downloads="cd /mnt/c/Users/\$(whoami)/Downloads"
alias cd-documents="cd /mnt/c/Users/\$(whoami)/Documents"
alias cd-pictures="cd /mnt/c/Users/\$(whoami)/Pictures"

# === NETWORK UTILITIES ===
alias wsl-ip="hostname -I | awk '{print \$1}'"
alias windows-ip="cat /etc/resolv.conf | grep nameserver | awk '{print \$2}'"
alias show-network-info="echo 'WSL IP: \$(wsl-ip)' && echo 'Windows IP: \$(windows-ip)'"

# Port forwarding helpers
forward-port() {
    local port=$1
    if [ -z "$port" ]; then
        echo "Usage: forward-port <port>"
        return 1
    fi
    echo "Forwarding port $port from WSL to Windows..."
    netsh.exe interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$(wsl-ip)
}

remove-port-forward() {
    local port=$1
    if [ -z "$port" ]; then
        echo "Usage: remove-port-forward <port>"
        return 1
    fi
    echo "Removing port forward for port $port..."
    netsh.exe interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0
}

list-port-forwards() {
    echo "Current port forwards:"
    netsh.exe interface portproxy show v4tov4
}

# === DEVELOPMENT SHORTCUTS ===
# Quick project setup in proper directories
setup-fullstack-workspace() {
    local project_name=$1
    if [ -z "$project_name" ]; then
        echo "Usage: setup-fullstack-workspace <project-name>"
        return 1
    fi
    
    mkdir -p "$HOME/Projects/$project_name"
    cd "$HOME/Projects/$project_name"
    mkdir -p frontend backend database docs
    
    echo "# $project_name" > README.md
    echo "node_modules/" > .gitignore
    echo ".env" >> .gitignore
    echo "*.log" >> .gitignore
    
    git init
    code .
    
    echo "✅ Fullstack workspace '$project_name' created successfully!"
}

# Docker utilities for WSL
alias docker-status="docker version && docker-compose version"
alias docker-clean="docker system prune -af"
alias docker-stop-all="docker stop \$(docker ps -aq)"
alias docker-remove-all="docker rm \$(docker ps -aq)"

# WSL-specific Git configuration
setup-git-for-wsl() {
    echo "🔧 Configuring Git for WSL environment..."
    git config --global core.autocrlf true
    git config --global core.filemode false
    git config --global core.editor "code --wait"
    echo "✅ Git configured for WSL!"
}

# Memory and resource monitoring
alias wsl-resources="echo 'Memory:' && free -h && echo '' && echo 'Disk:' && df -h / && echo '' && echo 'CPU:' && top -bn1 | grep 'Cpu(s)'"

# WSL update and maintenance
wsl-maintenance() {
    echo "🧹 Running WSL maintenance tasks..."
    
    # Update package lists
    sudo apt update
    
    # Upgrade packages
    sudo apt upgrade -y
    
    # Clean up packages
    sudo apt autoremove -y
    sudo apt autoclean
    
    # Clean npm cache if available
    if command -v npm &> /dev/null; then
        npm cache clean --force
    fi
    
    # Clean pip cache if available
    if command -v pip3 &> /dev/null; then
        pip3 cache purge 2>/dev/null || true
    fi
    
    # Docker cleanup if available
    if command -v docker &> /dev/null; then
        docker system prune -f
    fi
    
    echo "✅ WSL maintenance completed!"
}

# Quick WSL restart function
wsl-restart() {
    echo "🔄 Restarting WSL..."
    cmd.exe /c "wsl --shutdown"
    echo "WSL will restart automatically when you open a new terminal"
}

# Environment information
wsl-info() {
    echo "🖥️  WSL Development Environment Information"
    echo "==========================================="
    echo ""
    echo "📍 System Information:"
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "WSL Version: $(cat /proc/version | grep -oP 'WSL\d?' || echo 'WSL 1')"
    echo "Distribution: $(lsb_release -i | cut -f2)"
    echo ""
    echo "🌐 Network:"
    echo "WSL IP: $(wsl-ip)"
    echo "Windows IP: $(windows-ip)"
    echo ""
    echo "🛠️  Development Tools:"
    echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
    echo "npm: $(npm --version 2>/dev/null || echo 'Not installed')"
    echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
    echo "Git: $(git --version 2>/dev/null || echo 'Not installed')"
    echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
    echo "VS Code: $(code --version 2>/dev/null | head -1 || echo 'Not installed')"
    echo ""
    echo "🗄️  Services Status:"
    echo "MySQL: $(sudo service mysql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"
    echo "PostgreSQL: $(sudo service postgresql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"
    echo "Redis: $(sudo service redis-server status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"
    echo ""
    echo "💡 Quick Commands:"
    echo "start-all-dev-services  - Start all development services"
    echo "stop-all-dev-services   - Stop all development services"
    echo "check-all-services      - Check status of all services"
    echo "wsl-maintenance         - Run maintenance tasks"
    echo "wsl-restart             - Restart WSL"
    echo "setup-fullstack-workspace <name> - Create new fullstack project"
}

EOF

    # Source the aliases in .zshrc if not already done
    if ! grep -q ".wsl_dev_aliases.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# WSL Development Environment Aliases" >> "$HOME/.zshrc"
        echo "source ~/.wsl_dev_aliases.zsh" >> "$HOME/.zshrc"
        log_success "WSL development aliases added to .zshrc"
    fi
    
    log_success "WSL development environment configured successfully"
}

# Setup auto-start services script
setup_auto_start_services() {
    log_section "SETTING UP AUTO-START SERVICES"
    
    local startup_script="$HOME/start-wsl-services.sh"
    cat > "$startup_script" << 'EOF'
#!/bin/bash

# WSL Services Auto-Start Script
# Add this to your .zshrc or .bashrc to auto-start services

echo "🚀 Starting WSL development services..."

# Function to start service if not running
start_service_if_needed() {
    local service=$1
    local name=$2
    
    if ! sudo service $service status >/dev/null 2>&1; then
        echo "Starting $name..."
        sudo service $service start >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "✅ $name started successfully"
        else
            echo "❌ Failed to start $name"
        fi
    else
        echo "✅ $name is already running"
    fi
}

# Start services
start_service_if_needed mysql "MySQL"
start_service_if_needed postgresql "PostgreSQL"
start_service_if_needed redis-server "Redis"

echo "🎉 WSL services startup completed!"
EOF

    chmod +x "$startup_script"
    
    # Optionally add to .zshrc for auto-start
    read -p "Do you want to auto-start services when opening terminal? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if ! grep -q "start-wsl-services.sh" "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo "# Auto-start WSL development services" >> "$HOME/.zshrc"
            echo "# $HOME/start-wsl-services.sh" >> "$HOME/.zshrc"
            echo "# Uncomment the line above to enable auto-start" >> "$HOME/.zshrc"
            log_info "Auto-start configuration added to .zshrc (commented out)"
            log_info "Uncomment the line in .zshrc to enable auto-start"
        fi
    fi
    
    log_success "Auto-start services script created at: $startup_script"
}

# Create development workspace structure
setup_development_workspace() {
    log_section "SETTING UP DEVELOPMENT WORKSPACE"
    
    # Create development directories
    mkdir -p "$HOME/Projects/frontend"
    mkdir -p "$HOME/Projects/backend"
    mkdir -p "$HOME/Projects/fullstack"
    mkdir -p "$HOME/Projects/mobile"
    mkdir -p "$HOME/Projects/devops"
    mkdir -p "$HOME/Projects/learning"
    mkdir -p "$HOME/Scripts"
    mkdir -p "$HOME/Templates"
    
    # Create project templates
    local templates_dir="$HOME/Templates"
    
    # React template
    cat > "$templates_dir/package.json.react" << 'EOF'
{
  "name": "PROJECT_NAME",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.16.4",
    "@testing-library/react": "^13.3.0",
    "@testing-library/user-event": "^13.5.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "web-vitals": "^2.1.4"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF

    # Node.js Express template
    cat > "$templates_dir/package.json.express" << 'EOF'
{
  "name": "PROJECT_NAME",
  "version": "1.0.0",
  "description": "",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.1",
    "cors": "^2.8.5",
    "dotenv": "^16.0.1",
    "helmet": "^5.1.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.19",
    "jest": "^28.1.3"
  }
}
EOF

    # Python requirements template
    cat > "$templates_dir/requirements.txt.django" << 'EOF'
Django>=4.1.0
djangorestframework>=3.14.0
django-cors-headers>=3.13.0
python-decouple>=3.6
psycopg2-binary>=2.9.3
redis>=4.3.4
celery>=5.2.7
pytest-django>=4.5.2
black>=22.6.0
flake8>=5.0.4
EOF

    cat > "$templates_dir/requirements.txt.flask" << 'EOF'
Flask>=2.2.0
Flask-SQLAlchemy>=2.5.1
Flask-Migrate>=3.1.0
Flask-CORS>=3.0.10
python-decouple>=3.6
psycopg2-binary>=2.9.3
redis>=4.3.4
pytest>=7.1.2
black>=22.6.0
flake8>=5.0.4
EOF

    log_success "Development workspace structure created"
    log_info "Available directories:"
    log_info "  ~/Projects/frontend   - React, Vue, Angular projects"
    log_info "  ~/Projects/backend    - Node.js, Python, API projects"
    log_info "  ~/Projects/fullstack  - Full-stack applications"
    log_info "  ~/Projects/mobile     - React Native, Flutter projects"
    log_info "  ~/Projects/devops     - Docker, CI/CD configurations"
    log_info "  ~/Projects/learning   - Learning and experimental projects"
    log_info "  ~/Templates          - Project templates"
}

# Setup Windows Terminal integration
setup_windows_terminal_integration() {
    log_section "SETTING UP WINDOWS TERMINAL INTEGRATION"
    
    local wt_settings="/mnt/c/Users/$(whoami)/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    
    if [ -f "$wt_settings" ]; then
        log_info "Windows Terminal settings found"
        log_info "Consider adding WSL profile with these settings:"
        echo ""
        echo "{"
        echo '  "guid": "{your-guid-here}",'
        echo '  "name": "WSL Development",'
        echo '  "source": "Windows.Terminal.Wsl",'
        echo '  "startingDirectory": "~",'
        echo '  "fontFace": "Cascadia Code PL",'
        echo '  "fontSize": 11,'
        echo '  "colorScheme": "One Half Dark",'
        echo '  "backgroundImage": null,'
        echo '  "useAcrylic": false'
        echo "}"
        echo ""
    else
        log_warning "Windows Terminal not found or settings not accessible"
    fi
}

# Main execution function
main() {
    log_section "WSL ADVANCED CONFIGURATION"
    log_info "Setting up advanced WSL development environment..."
    
    # Check if running in WSL
    if ! [[ -f /proc/version ]] || ! grep -qi "microsoft\|wsl" /proc/version; then
        log_error "This script is designed for WSL environments only"
        exit 1
    fi
    
    echo -e "${YELLOW}This script will configure advanced WSL settings and development environment.${NC}"
    echo -e "${YELLOW}Some operations may require Windows host access.${NC}"
    echo ""
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Configuration cancelled by user"
        exit 0
    fi
    
    configure_wsl_settings
    setup_wsl_development_env
    setup_auto_start_services
    setup_development_workspace
    setup_windows_terminal_integration
    
    log_section "WSL ADVANCED CONFIGURATION COMPLETED!"
    echo -e "${GREEN}"
    echo "🎉 Advanced WSL configuration completed successfully!"
    echo ""
    echo "📋 What was configured:"
    echo "  ✅ WSL performance settings (.wslconfig)"
    echo "  ✅ Development environment aliases"
    echo "  ✅ Auto-start services script"
    echo "  ✅ Development workspace structure"
    echo "  ✅ Windows Terminal integration info"
    echo ""
    echo "🔄 Next steps:"
    echo "  1. Restart WSL: wsl --shutdown (from Windows)"
    echo "  2. Restart your terminal or run: source ~/.zshrc"
    echo "  3. Run 'wsl-info' to see your environment status"
    echo "  4. Use 'start-all-dev-services' to start development services"
    echo ""
    echo "💡 New commands available:"
    echo "  - wsl-info: Show environment information"
    echo "  - start-all-dev-services: Start all development services"
    echo "  - setup-fullstack-workspace <name>: Create new project"
    echo "  - wsl-maintenance: Run maintenance tasks"
    echo -e "${NC}"
}

# Run main function
main "$@"
