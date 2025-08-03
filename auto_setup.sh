#!/bin/bash

# =============================================================================
# AUTO SETUP SCRIPT FOR FULLSTACK DEVELOPER ENVIRONMENT ON UBUNTU
# =============================================================================
# Author: Nguyen DB
# Description: Automated setup script for fullstack development environment
# Includes: Development tools, Node.js, Python, Docker, Database, Vim, VS Code
# =============================================================================

# Load common functions and constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || {
    echo "❌ ERROR: Cannot load common library. Please ensure lib/common.sh exists."
    exit 1
}

# Initialize common settings
init_common

# Global variables
IS_WSL=false

# =============================================================================
# MAIN SETUP FUNCTIONS
# =============================================================================

# Update system packages
update_system() {
    log_section "UPDATING SYSTEM PACKAGES"
    log_namespace "SYSTEM" "INFO" "Updating package lists..."
    safe_execute "sudo apt update"
    
    log_namespace "SYSTEM" "INFO" "Upgrading existing packages..."
    safe_execute "sudo apt upgrade -y"
    
    log_namespace "SYSTEM" "INFO" "Installing essential build tools..."
    safe_execute "sudo apt install -y build-essential software-properties-common apt-transport-https ca-certificates"
    
    log_namespace "SYSTEM" "SUCCESS" "System updated successfully"
}

# Install basic development tools
install_dev_tools() {
    log_section "INSTALLING DEVELOPMENT TOOLS"
    
    local tools=(
        "git"
        "vim"
        "curl"
        "wget"
        "unzip"
        "zip"
        "tree"
        "htop"
        "neofetch"
        "zsh"
        "tmux"
        "jq"
        "make"
        "gcc"
        "g++"
        "python3-pip"
    )
    
    log_namespace "TOOLS" "INFO" "Installing development tools: ${tools[*]}"
    
    for tool in "${tools[@]}"; do
        if ! package_installed "$tool"; then
            log_namespace "TOOLS" "INFO" "Installing $tool..."
            safe_execute "sudo apt install -y $tool"
        else
            log_namespace "TOOLS" "DEBUG" "$tool already installed"
        fi
    done
    
    log_namespace "TOOLS" "SUCCESS" "Development tools installed successfully"
}


# Install and configure Git
setup_git() {
    log_section "CONFIGURING GIT"
    
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed"
        return 1
    fi 

    log_section "Enter your Git configuration username and email"
    log_info "Configuring Git username information..."
    read -p "Enter your Git username: " git_username
    log_info "Configuring Git email information..."
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    
    log_success "Git configured successfully"
}

# Install Node.js and npm
install_nodejs() {
    log_section "INSTALLING NODE.JS AND NPM"
    
    # Install Node.js using NodeSource repository
    log_info "Adding NodeSource repository..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    
    log_info "Installing Node.js..."
    sudo apt install -y nodejs
    
    # Install global npm packages
    log_info "Installing global npm packages..."
    local npm_packages=(
        "yarn" "pm2" "nodemon" "create-react-app" 
        "@vue/cli" "@angular/cli" "typescript" "ts-node"
        "eslint" "prettier" "live-server"
    )
    
    for package in "${npm_packages[@]}"; do
        log_info "Installing $package..."
        sudo npm install -g "$package"
    done
    
    log_success "Node.js and npm packages installed successfully"
    node --version
    npm --version
}

# Install Python and pip
install_python() {
    log_section "INSTALLING PYTHON AND PIP"
    
    log_info "Installing Python 3 and pip..."
    sudo apt install -y python3 python3-pip python3-venv python3-dev
    
    # Install commonly used Python packages
    log_info "Installing Python packages..."
    local python_packages=(
        "virtualenv" "pipenv" "django" "flask" "fastapi"
        "requests" "pytest" "black" "flake8" "jupyter"
        "pandas" "numpy" "matplotlib" "seaborn"
    )
    
    for package in "${python_packages[@]}"; do
        log_info "Installing $package..."
        pip3 install --user "$package"
    done
    
    log_success "Python and packages installed successfully"
    python3 --version
    pip3 --version
}

# Install Docker and Docker Compose
install_docker() {
    log_section "INSTALLING DOCKER AND DOCKER COMPOSE"
    
    # Check if Docker is already working (Docker Desktop case)
    if docker --version >/dev/null 2>&1 && docker ps >/dev/null 2>&1; then
        log_success "Docker is already available and working!"
        log_info "Docker version: $(docker --version)"
        
        # Check Docker Compose
        if docker compose version >/dev/null 2>&1; then
            log_success "Docker Compose is also available: $(docker compose version --short 2>/dev/null || echo 'v2+')"
        else
            log_warning "Docker Compose not found, but Docker is working"
        fi
        
        # Ensure user is in docker group for better permissions
        if ! groups $USER | grep -q docker 2>/dev/null; then
            log_info "Adding user to docker group for better permissions..."
            sudo usermod -aG docker $USER
            log_warning "Please log out and log back in for Docker group changes to take effect"
        fi
        
        log_success "Docker setup already complete - skipping installation"
        return 0
    fi
    
    if [[ "$IS_WSL" == true ]]; then
        log_info "WSL detected - configuring Docker for WSL environment"
        
        # Check if Docker Desktop is running on Windows (common case)
        if [[ -S /var/run/docker.sock ]] || [[ -n "$DOCKER_HOST" ]]; then
            log_info "Docker Desktop appears to be available via WSL integration"
            
            # Install only Docker CLI if not present
            if ! command -v docker &> /dev/null; then
                log_info "Installing Docker CLI for WSL integration..."
                
                # Remove old versions
                sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
                
                # Install Docker CLI
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                
                sudo apt update
                sudo apt install -y docker-ce-cli docker-compose-plugin
                
                # Add user to docker group
                sudo usermod -aG docker $USER
            else
                log_success "Docker CLI already installed"
            fi
        else
            log_info "Docker Desktop not detected - installing Docker CLI for manual setup"
            
            # Remove old versions
            sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
            
            # Install Docker CLI
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            sudo apt update
            sudo apt install -y docker-ce-cli docker-compose-plugin
            
            # Add user to docker group
            sudo usermod -aG docker $USER
        fi
        
        log_warning "WSL Docker Setup Notes:"
        log_warning "1. If using Docker Desktop: Make sure it's installed and running on Windows"
        log_warning "2. Enable WSL 2 integration in Docker Desktop settings"
        log_warning "3. Restart WSL after Docker Desktop is configured"
        log_warning "4. If not using Docker Desktop: Install Docker Desktop or set up remote Docker"
        
    else
        log_info "Native Ubuntu detected - installing full Docker Engine"
        
        # Check if user wants to install Docker Engine or use Docker Desktop
        echo -e "\n${YELLOW}Docker Installation Options:${NC}"
        echo "1. Install Docker Engine (recommended for servers)"
        echo "2. Skip installation (if using Docker Desktop)"
        echo ""
        read -p "Choose option (1-2) [1]: " docker_choice
        docker_choice=${docker_choice:-1}
        
        case $docker_choice in
            2)
                log_info "Skipping Docker Engine installation"
                log_info "Make sure Docker Desktop is installed if you plan to use Docker"
                return 0
                ;;
            1|*)
                # Remove old versions
                sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
                
                # Install Docker Engine
                log_info "Installing Docker Engine..."
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                
                sudo apt update
                sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
                
                # Add user to docker group
                sudo usermod -aG docker $USER
                
                # Start and enable Docker service
                sudo systemctl start docker
                sudo systemctl enable docker
                
                log_warning "Please log out and log back in for Docker group changes to take effect"
                ;;
        esac
    fi
    
    log_success "Docker configuration completed for your environment"
}

# Install databases
install_databases() {
    log_section "INSTALLING DATABASES"
    
    if [[ "$IS_WSL" == true ]]; then
        log_info "WSL detected - Installing databases for WSL environment"
        
        # MySQL
        log_info "Installing MySQL..."
        sudo apt install -y mysql-server mysql-client
        
        # PostgreSQL
        log_info "Installing PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib
        
        # Redis
        log_info "Installing Redis..."
        sudo apt install -y redis-server
        
        # SQLite (usually pre-installed)
        sudo apt install -y sqlite3
        
        log_warning "WSL Database Setup Notes:"
        log_warning "1. Services don't auto-start in WSL. Use: sudo service mysql start"
        log_warning "2. For PostgreSQL: sudo service postgresql start"
        log_warning "3. For Redis: sudo service redis-server start"
        log_warning "4. Consider adding these to your .bashrc/.zshrc for auto-start"
        
    else
        log_info "Native Ubuntu detected - Installing and starting database services"
        
        # MySQL
        log_info "Installing MySQL..."
        sudo apt install -y mysql-server mysql-client
        
        # PostgreSQL
        log_info "Installing PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib
        
        # Redis
        log_info "Installing Redis..."
        sudo apt install -y redis-server
        
        # SQLite (usually pre-installed)
        sudo apt install -y sqlite3
        
        # Start and enable services on native Ubuntu
        log_info "Starting database services..."
        sudo systemctl start mysql
        sudo systemctl enable mysql
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
        sudo systemctl start redis-server
        sudo systemctl enable redis-server
    fi
    
    log_success "Databases installed successfully"
}

# Install VS Code
install_vscode() {
    log_section "INSTALLING VISUAL STUDIO CODE"
    
    if [[ "$IS_WSL" == true ]]; then
        log_info "WSL detected - VS Code installation notes"
        log_warning "WSL VS Code Setup:"
        log_warning "1. Install VS Code on Windows host if not already installed"
        log_warning "2. Install 'Remote - WSL' extension in VS Code"
        log_warning "3. Use 'code .' command from WSL to open projects in VS Code"
        log_warning "4. Skipping VS Code installation in WSL as it should run on Windows host"
        
        return 0
    else
        log_info "Native Ubuntu detected - Installing VS Code"
        
        log_info "Adding Microsoft GPG key and repository..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        
        sudo apt update
        sudo apt install -y code
        
        log_success "VS Code installed successfully"
    fi
}

# Configure VS Code
configure_vscode() {
    log_section "CONFIGURING VISUAL STUDIO CODE"
    
    local vscode_dir="$HOME/.config/Code/User"
    mkdir -p "$vscode_dir"
    
    # Copy settings and keybindings
    if [ -f "vscode/settings.json" ]; then
        log_info "Copying VS Code settings..."
        cp vscode/settings.json "$vscode_dir/"
        log_success "VS Code settings copied"
    else
        log_warning "VS Code settings.json not found"
    fi
    
    if [ -f "vscode/keybindings.json" ]; then
        log_info "Copying VS Code keybindings..."
        cp vscode/keybindings.json "$vscode_dir/"
        log_success "VS Code keybindings copied"
    else
        log_warning "VS Code keybindings.json not found"
    fi
    
    log_success "VS Code configuration completed"
}

# Setup Vim configuration
setup_vim() {
    log_section "SETTING UP VIM CONFIGURATION"
    
    if ! command -v vim &> /dev/null; then
        log_error "Vim is not installed"
        return 1
    fi
    
    log_info "Setting up Vim configuration..."
    chmod +x setup_vim.sh
    ./setup_vim.sh
    
    log_success "Vim configuration completed"
    log_info "Run 'vim' and ':PlugInstall' to install plugins"
}

# Setup Zsh and aliases
setup_zsh() {
    log_section "SETTING UP ZSH AND ALIASES"
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed"
        return 1
    fi
    
    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Install useful Zsh plugins
    log_info "Installing Zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    
    # Configure .zshrc
    log_info "Configuring .zshrc..."
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    cat > "$HOME/.zshrc" << 'EOF'
# =============================================================================
# ZSH CONFIGURATION FOR FULLSTACK DEVELOPMENT
# =============================================================================

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    npm
    node
    python
    pip
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    history
    dirhistory
)

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='vim'

# Load custom aliases
if [ -f ~/.aliases.zsh ]; then
    source ~/.aliases.zsh
fi

# Load WSL-specific aliases (if running in WSL)
if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
    if [ -f ~/.wsl_dev_aliases.zsh ]; then
        source ~/.wsl_dev_aliases.zsh
    fi
fi

# Node.js version manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Python virtual environment
export WORKON_HOME=$HOME/.virtualenvs
if command -v virtualenvwrapper.sh &> /dev/null; then
    source virtualenvwrapper.sh
fi

# Go lang (if installed)
if [ -d "/usr/local/go" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

# Custom PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Development shortcuts
export PROJECTS="$HOME/Projects"
alias projects="cd $PROJECTS"

# WSL-specific settings
if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
    # Display motd with dev info
    if [ -f ~/.wsl_dev_aliases.zsh ]; then
        echo "💻 WSL Development Environment Ready!"
        echo "💡 Type 'wsl-info' for environment details"
        echo "🚀 Type 'start-all-dev-services' to start services"
    fi
fi
EOF

    # Copy or source the existing aliases file
    if [ -f ".aliases.zsh" ]; then
        cp ".aliases.zsh" "$HOME/.aliases.zsh"
        log_success "Aliases file copied to home directory"
    fi
    
    # Change default shell to zsh
    if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
        log_info "Changing default shell to zsh..."
        chsh -s $(which zsh)
        log_success "Default shell changed to zsh"
        log_warning "Please restart your terminal or log out and log back in"
    fi
    
    log_success "Zsh and aliases setup completed"
}

# Install additional useful tools
install_additional_tools() {
    log_section "INSTALLING ADDITIONAL TOOLS"
    
    if [[ "$IS_WSL" == true ]]; then
        log_info "WSL detected - Installing command-line tools only"
        log_warning "WSL Additional Tools Notes:"
        log_warning "1. GUI applications should be installed on Windows host"
        log_warning "2. For development tools like Postman, Discord, etc., install on Windows"
        log_warning "3. WSL is optimized for command-line development tools"
        
        # Install command-line tools for WSL
        log_info "Installing command-line tools for WSL..."
        local wsl_tools=(
            "lynx"          # Text-based web browser
            "elinks"        # Another text browser
            "w3m"           # Text browser with image support
            "ncdu"          # Disk usage analyzer
            "ranger"        # File manager
            "bat"           # Better cat with syntax highlighting
            "fd-find"       # Better find
            "ripgrep"       # Better grep
            "fzf"           # Fuzzy finder
        )
        
        for tool in "${wsl_tools[@]}"; do
            log_info "Installing $tool..."
            sudo apt install -y "$tool" 2>/dev/null || log_warning "Failed to install $tool"
        done
        
    else
        log_info "Native Ubuntu detected - Installing GUI applications"
        
        # Install GUI applications for native Ubuntu
        local gui_tools=(
            "firefox"
            "chromium-browser"
            "gimp"
            "vlc"
            "thunderbird"
            "libreoffice"
            "filezilla"
        )
        
        for tool in "${gui_tools[@]}"; do
            log_info "Installing $tool..."
            sudo apt install -y "$tool" 2>/dev/null || log_warning "Failed to install $tool"
        done
        
        # Install Snap packages
        log_info "Installing Snap packages..."
        sudo apt install -y snapd
        
        local snap_tools=(
            "postman"
            "slack --classic"
            "discord"
            "spotify"
            "code --classic"
        )
        
        for tool in "${snap_tools[@]}"; do
            log_info "Installing $tool via snap..."
            sudo snap install $tool 2>/dev/null || log_warning "Failed to install $tool"
        done
        
        # Install Google Chrome
        log_info "Installing Google Chrome..."
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
        sudo apt update
        sudo apt install -y google-chrome-stable 2>/dev/null || log_warning "Failed to install Google Chrome"
    fi
    
    log_success "Additional tools installation completed"
}

# Setup development directories
setup_dev_directories() {
    log_section "SETTING UP DEVELOPMENT DIRECTORIES"
    
    log_info "Creating development directory structure..."
    
    # Create main project directories
    mkdir -p "$HOME/Projects"/{frontend,backend,fullstack,mobile,devops,learning}
    mkdir -p "$HOME/Scripts"
    mkdir -p "$HOME/Templates"
    mkdir -p "$HOME/Backups"
    
    # Create subdirectories for different technologies
    mkdir -p "$HOME/Projects/frontend"/{react,vue,angular,vanilla}
    mkdir -p "$HOME/Projects/backend"/{nodejs,python,php,go,rust}
    mkdir -p "$HOME/Projects/mobile"/{react-native,flutter,ionic}
    mkdir -p "$HOME/Projects/devops"/{docker,kubernetes,ci-cd,scripts}
    
    # Create template files
    local templates_dir="$HOME/Templates"
    
    # README template
    cat > "$templates_dir/README.md" << 'EOF'
# Project Name

## Description
Brief description of the project.

## Technologies
- Technology 1
- Technology 2
- Technology 3

## Installation
```bash
# Installation steps
```

## Usage
```bash
# Usage examples
```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License.
EOF

    # .gitignore template
    cat > "$templates_dir/.gitignore" << 'EOF'
# Dependencies
node_modules/
vendor/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# Build outputs
dist/
build/
out/

# Cache
.cache/
.parcel-cache/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
.venv/
pip-log.txt
pip-delete-this-directory.txt

# Java
*.class
*.jar
*.war
*.ear
target/

# C/C++
*.o
*.a
*.so
*.exe
EOF

    # Create workspace info file
    cat > "$HOME/Projects/README.md" << 'EOF'
# Development Workspace

This directory contains all your development projects organized by category:

## Structure
```
Projects/
├── frontend/          # Frontend projects (React, Vue, Angular)
├── backend/           # Backend projects (Node.js, Python, etc.)
├── fullstack/         # Full-stack applications
├── mobile/            # Mobile applications
├── devops/            # DevOps configurations and scripts
└── learning/          # Learning and experimental projects
```

## Quick Start Commands
- `make create-react` - Create new React project
- `make create-vue` - Create new Vue project  
- `make create-node` - Create new Node.js project
- `make create-python` - Create new Python project

## Templates
Check `~/Templates/` for project templates and boilerplates.
EOF

    log_success "Development directories created successfully"
    log_info "Main directory: $HOME/Projects"
    log_info "Templates: $HOME/Templates"
    log_info "Scripts: $HOME/Scripts"
    log_info "Backups: $HOME/Backups"
}

# Cleanup
cleanup() {
    log_section "CLEANING UP INSTALLATION"
    
    log_info "Cleaning up temporary files..."
    sudo apt autoremove -y
    sudo apt autoclean
    
    # Clean npm cache if npm is installed
    if command -v npm &> /dev/null; then
        npm cache clean --force 2>/dev/null || true
    fi
    
    # Clean pip cache if pip is installed
    if command -v pip3 &> /dev/null; then
        pip3 cache purge 2>/dev/null || true
    fi
    
    log_success "Cleanup completed"
}

# Display final information
show_completion_info() {
    log_section "INSTALLATION COMPLETED SUCCESSFULLY!"
    
    echo -e "${GREEN}"
    echo "🎉 Fullstack Developer Environment Setup Completed!"
    echo ""
    echo "📋 What was installed:"
    echo "  ✅ Development tools (Git, Vim, cURL, etc.)"
    echo "  ✅ Node.js and npm packages"
    echo "  ✅ Python 3 and pip packages"
    echo "  ✅ Docker and Docker Compose"
    echo "  ✅ Database servers (MySQL, PostgreSQL, Redis)"
    if [[ "$IS_WSL" == true ]]; then
        echo "  ✅ WSL-optimized configuration"
    else
        echo "  ✅ VS Code and essential extensions"
        echo "  ✅ GUI applications and tools"
    fi
    echo "  ✅ Vim configuration with plugins"
    echo "  ✅ Zsh with Oh My Zsh and plugins"
    echo "  ✅ Development directory structure"
    echo "  ✅ Useful aliases and shortcuts"
    echo ""
    echo "🔄 Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    if [[ "$IS_WSL" == true ]]; then
        echo "  2. Run: make wsl-setup (for additional WSL configuration)"
        echo "  3. Use 'make dev-start' to start development services"
        echo "  4. Run 'wsl-info' to see your environment status"
    else
        echo "  2. Run: make post-setup (for additional configuration)"
        echo "  3. Use 'make dev-start' to start development services"
    fi
    echo "  4. Create your first project with 'make create-react PROJECT_NAME'"
    echo ""
    echo "📚 Useful commands:"
    echo "  - make help           : Show all available commands"
    echo "  - make info           : Show system information"
    echo "  - make check          : Check environment status"
    echo "  - make dev-start      : Start development services"
    echo "  - make dev-stop       : Stop development services"
    echo "  - make maintenance    : Run system maintenance"
    echo ""
    if [[ "$IS_WSL" == true ]]; then
        echo "🪟 WSL-specific commands:"
        echo "  - wsl-info            : Show WSL environment details"
        echo "  - start-all-dev-services : Start all development services"
        echo "  - setup-fullstack-workspace <name> : Create new project"
        echo ""
    fi
    echo "📖 Documentation:"
    echo "  - Check README.md for detailed usage instructions"
    echo "  - Visit ~/Projects/ for your development workspace"
    echo "  - Check ~/Templates/ for project templates"
    echo ""
    echo "🆘 If you encounter issues:"
    echo "  - Run 'make check' to diagnose problems"
    echo "  - Check ~/.zshrc for configuration"
    echo "  - Look at logs in this terminal output"
    echo -e "${NC}"
}

# Make scripts executable
make_scripts_executable() {
    log_info "Making scripts executable..."
    chmod +x auto_setup.sh
    chmod +x setup_vim.sh
    chmod +x install_extensions.sh
    chmod +x check_environment.sh
    chmod +x post_setup.sh
    chmod +x wsl_post_setup.sh 2>/dev/null || true
    chmod +x wsl_advanced_setup.sh 2>/dev/null || true
    log_success "Scripts made executable"
}

# Main execution function
main() {
    log_section "FULLSTACK DEVELOPER ENVIRONMENT SETUP"
    log_info "Starting automated setup for Ubuntu..."
    log_warning "This script will install and configure multiple development tools (y/N)"

    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled by user"
        exit 0
    fi
    
    # Check prerequisites
    check_root
    detect_wsl
    
    # Make scripts executable
    make_scripts_executable
    
    # Execute setup steps
    update_system
    install_dev_tools
    setup_git
    install_nodejs
    install_python
    install_docker
    install_databases
    install_vscode
    configure_vscode
    setup_vim
    setup_zsh
    install_additional_tools
    setup_dev_directories
    cleanup
    
    # Show completion info
    show_completion_info
}

# Run main function
main "$@"
