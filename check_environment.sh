#!/bin/bash

# =============================================================================
# ENVIRONMENT CHECKER AND TROUBLESHOOTER
# =============================================================================
# This script checks the development environment and provides troubleshooting

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

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

# Check if command exists
check_command() {
    local cmd=$1
    local name=$2
    local install_cmd=$3
    
    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>/dev/null | head -n1 || echo "Unknown version")
        log_success "$name: $version"
        return 0
    else
        log_error "$name: Not installed"
        if [ -n "$install_cmd" ]; then
            log_info "To install: $install_cmd"
        fi
        return 1
    fi
}

# Check service status
check_service() {
    local service=$1
    local name=$2
    
    if systemctl is-active --quiet "$service"; then
        log_success "$name service: Active"
        return 0
    else
        log_error "$name service: Inactive"
        log_info "To start: sudo systemctl start $service"
        log_info "To enable: sudo systemctl enable $service"
        return 1
    fi
}

# Check port availability
check_port() {
    local port=$1
    local service=$2
    
    if lsof -i:$port &> /dev/null; then
        local process=$(lsof -i:$port | tail -n1 | awk '{print $1}')
        log_warning "Port $port ($service): In use by $process"
        return 1
    else
        log_success "Port $port ($service): Available"
        return 0
    fi
}

# Check development tools
check_dev_tools() {
    log_section "DEVELOPMENT TOOLS"
    
    local total=0
    local installed=0
    
    tools=(
        "git:Git:sudo apt install git"
        "vim:Vim:sudo apt install vim"
        "curl:cURL:sudo apt install curl"
        "wget:wget:sudo apt install wget"
        "unzip:unzip:sudo apt install unzip"
        "tree:tree:sudo apt install tree"
        "htop:htop:sudo apt install htop"
        "jq:jq:sudo apt install jq"
        "code:VS Code:Install from https://code.visualstudio.com/"
    )
    
    for tool in "${tools[@]}"; do
        IFS=':' read -r cmd name install_cmd <<< "$tool"
        ((total++))
        if check_command "$cmd" "$name" "$install_cmd"; then
            ((installed++))
        fi
    done
    
    log_info "Development tools: $installed/$total installed"
}

# Check programming languages
check_languages() {
    log_section "PROGRAMMING LANGUAGES"
    
    local total=0
    local installed=0
    
    # Node.js
    ((total++))
    if check_command "node" "Node.js" "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install nodejs"; then
        ((installed++))
        check_command "npm" "npm" ""
    fi
    
    # Python
    ((total++))
    if check_command "python3" "Python 3" "sudo apt install python3"; then
        ((installed++))
        check_command "pip3" "pip3" "sudo apt install python3-pip"
    fi
    
    log_info "Programming languages: $installed/$total installed"
}

# Check databases
check_databases() {
    log_section "DATABASES"
    
    local total=0
    local installed=0
    
    # MySQL
    ((total++))
    if check_command "mysql" "MySQL Client" "sudo apt install mysql-server mysql-client"; then
        ((installed++))
        check_service "mysql" "MySQL"
        check_port "3306" "MySQL"
    fi
    
    # PostgreSQL
    ((total++))
    if check_command "psql" "PostgreSQL Client" "sudo apt install postgresql postgresql-contrib"; then
        ((installed++))
        check_service "postgresql" "PostgreSQL"
        check_port "5432" "PostgreSQL"
    fi
    
    # Redis
    ((total++))
    if check_command "redis-cli" "Redis CLI" "sudo apt install redis-server"; then
        ((installed++))
        check_service "redis-server" "Redis"
        check_port "6379" "Redis"
    fi
    
    # SQLite
    ((total++))
    if check_command "sqlite3" "SQLite" "sudo apt install sqlite3"; then
        ((installed++))
    fi
    
    log_info "Databases: $installed/$total installed"
}

# Check Docker
check_docker() {
    log_section "DOCKER & CONTAINERIZATION"
    
    if check_command "docker" "Docker" "Install from https://docs.docker.com/engine/install/ubuntu/"; then
        check_service "docker" "Docker"
        
        # Check if user is in docker group
        if groups $USER | grep -q docker; then
            log_success "User in docker group: Yes"
        else
            log_error "User in docker group: No"
            log_info "To add user to docker group: sudo usermod -aG docker $USER"
            log_info "Then log out and log back in"
        fi
        
        # Check Docker Compose
        if docker compose version &> /dev/null; then
            log_success "Docker Compose: $(docker compose version --short)"
        else
            log_error "Docker Compose: Not available"
        fi
    fi
}

# Check VS Code extensions
check_vscode_extensions() {
    log_section "VS CODE EXTENSIONS"
    
    if ! command -v code &> /dev/null; then
        log_error "VS Code not installed, skipping extension check"
        return
    fi
    
    essential_extensions=(
        "ms-python.python"
        "ms-vscode.vscode-typescript-next"
        "esbenp.prettier-vscode"
        "ms-vscode.vscode-eslint"
        "vscodevim.vim"
        "ms-azuretools.vscode-docker"
        "zhuangtongfa.material-theme"
        "vscode-icons-team.vscode-icons"
    )
    
    local total=${#essential_extensions[@]}
    local installed=0
    
    for ext in "${essential_extensions[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            log_success "Extension $ext: Installed"
            ((installed++))
        else
            log_error "Extension $ext: Not installed"
            log_info "To install: code --install-extension $ext"
        fi
    done
    
    log_info "Essential VS Code extensions: $installed/$total installed"
}

# Check configuration files
check_config_files() {
    log_section "CONFIGURATION FILES"
    
    configs=(
        "$HOME/.vimrc:Vim configuration"
        "$HOME/.zshrc:Zsh configuration"
        "$HOME/.aliases.zsh:Custom aliases"
        "$HOME/.config/Code/User/settings.json:VS Code settings"
        "$HOME/.config/Code/User/keybindings.json:VS Code keybindings"
        "$HOME/.ssh/id_rsa:SSH private key"
        "$HOME/.ssh/id_rsa.pub:SSH public key"
    )
    
    local total=${#configs[@]}
    local found=0
    
    for config in "${configs[@]}"; do
        IFS=':' read -r file desc <<< "$config"
        if [ -f "$file" ]; then
            log_success "$desc: Found"
            ((found++))
        else
            log_warning "$desc: Not found"
        fi
    done
    
    log_info "Configuration files: $found/$total found"
}

# Check network connectivity
check_network() {
    log_section "NETWORK CONNECTIVITY"
    
    # Check internet connectivity
    if ping -c 1 google.com &> /dev/null; then
        log_success "Internet connectivity: Available"
    else
        log_error "Internet connectivity: Not available"
    fi
    
    # Check package repositories
    if apt list --upgradable &> /dev/null; then
        log_success "Package repositories: Accessible"
    else
        log_error "Package repositories: Not accessible"
    fi
    
    # Check common development ports
    common_ports=(
        "3000:React Dev Server"
        "8000:Django Dev Server"
        "5000:Flask Dev Server"
        "4200:Angular Dev Server"
        "8080:Common Dev Server"
    )
    
    for port_info in "${common_ports[@]}"; do
        IFS=':' read -r port desc <<< "$port_info"
        check_port "$port" "$desc"
    done
}

# System information
show_system_info() {
    log_section "SYSTEM INFORMATION"
    
    echo "OS: $(lsb_release -d | cut -f2 2>/dev/null || echo 'Unknown')"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "CPU: $(nproc) cores"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $2}') total, $(free -h | awk '/^Mem:/ {print $7}') available"
    echo "Disk: $(df -h / | awk 'NR==2 {print $4}') free on root partition"
    echo "Shell: $SHELL"
    echo "User: $USER"
    echo "Home: $HOME"
}

# Generate troubleshooting report
generate_report() {
    log_section "GENERATING TROUBLESHOOTING REPORT"
    
    local report_file="$HOME/environment_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "=== DEVELOPMENT ENVIRONMENT REPORT ==="
        echo "Generated on: $(date)"
        echo "User: $USER"
        echo "Hostname: $(hostname)"
        echo ""
        
        echo "=== SYSTEM INFO ==="
        lsb_release -a 2>/dev/null || echo "LSB not available"
        uname -a
        echo ""
        
        echo "=== INSTALLED PACKAGES ==="
        dpkg -l | grep -E "(git|vim|node|python|mysql|postgresql|redis|docker|code)" || echo "No relevant packages found"
        echo ""
        
        echo "=== RUNNING SERVICES ==="
        systemctl list-units --type=service --state=active | grep -E "(mysql|postgresql|redis|docker)" || echo "No relevant services running"
        echo ""
        
        echo "=== NETWORK ==="
        ip addr show
        echo ""
        
        echo "=== ENVIRONMENT VARIABLES ==="
        printenv | grep -E "(PATH|NODE|PYTHON|JAVA)" || echo "No relevant environment variables"
        
    } > "$report_file"
    
    log_success "Report generated: $report_file"
}

# Fix common issues
fix_issues() {
    log_section "FIXING COMMON ISSUES"
    
    read -p "Do you want to attempt automatic fixes for common issues? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    # Fix package lists
    log_info "Updating package lists..."
    sudo apt update
    
    # Fix broken packages
    log_info "Fixing broken packages..."
    sudo apt --fix-broken install -y
    
    # Update npm if Node.js is installed
    if command -v npm &> /dev/null; then
        log_info "Updating npm..."
        sudo npm install -g npm@latest
    fi
    
    # Fix pip if Python is installed
    if command -v pip3 &> /dev/null; then
        log_info "Upgrading pip..."
        pip3 install --upgrade pip --user
    fi
    
    # Start essential services
    services=("mysql" "postgresql" "redis-server" "docker")
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            log_info "Starting $service..."
            sudo systemctl start "$service" 2>/dev/null || true
        fi
    done
    
    log_success "Common fixes applied"
}

# Main menu
show_menu() {
    echo -e "\n${PURPLE}=== ENVIRONMENT CHECKER MENU ===${NC}"
    echo "1. Full system check"
    echo "2. Check development tools only"
    echo "3. Check databases only"
    echo "4. Check Docker only"
    echo "5. Check VS Code extensions only"
    echo "6. Show system information"
    echo "7. Generate troubleshooting report"
    echo "8. Fix common issues"
    echo "9. Exit"
    echo ""
    read -p "Choose an option (1-9): " choice
}

# Main execution
main() {
    log_section "DEVELOPMENT ENVIRONMENT CHECKER"
    
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
            case $choice in
                1)
                    show_system_info
                    check_dev_tools
                    check_languages
                    check_databases
                    check_docker
                    check_vscode_extensions
                    check_config_files
                    check_network
                    ;;
                2) check_dev_tools ;;
                3) check_databases ;;
                4) check_docker ;;
                5) check_vscode_extensions ;;
                6) show_system_info ;;
                7) generate_report ;;
                8) fix_issues ;;
                9) log_info "Goodbye!"; exit 0 ;;
                *) log_error "Invalid option" ;;
            esac
        done
    else
        # Run full check if script is called with arguments
        show_system_info
        check_dev_tools
        check_languages
        check_databases
        check_docker
        check_vscode_extensions
        check_config_files
        check_network
    fi
}

# Run main function
main "$@"
