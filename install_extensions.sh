#!/bin/bash

# =============================================================================
# VS CODE EXTENSIONS INSTALLER
# =============================================================================
# This script installs essential VS Code extensions for fullstack development

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
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

# Detect WSL environment
detect_wsl() {
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        return 0
    elif [[ -n "${WSL_DISTRO_NAME}" ]]; then
        return 0
    elif [[ $(uname -r) =~ Microsoft|microsoft|WSL|wsl ]]; then
        return 0
    else
        return 1
    fi
}

# Check if VS Code is available
if detect_wsl; then
    log_info "WSL environment detected"
    if ! command -v code &> /dev/null; then
        log_warning "VS Code command not found in WSL"
        log_warning "Make sure VS Code is installed on Windows with 'Remote - WSL' extension"
        log_warning "You can install extensions from VS Code on Windows or use this script after setting up VS Code properly"
        exit 1
    fi
else
    log_info "Native Ubuntu environment detected"
    if ! command -v code &> /dev/null; then
        log_error "VS Code is not installed. Please install it first using the auto_setup.sh script"
        exit 1
    fi
fi

log_info "Installing VS Code extensions for fullstack development..."

# Essential extensions
declare -A extensions=(
    # Language Support
    ["ms-python.python"]="Python language support"
    ["ms-vscode.vscode-typescript-next"]="TypeScript support"
    ["bradlc.vscode-tailwindcss"]="Tailwind CSS support"
    ["ms-vscode.vscode-json"]="JSON language support"
    
    # Formatters & Linters
    ["esbenp.prettier-vscode"]="Code formatter"
    ["ms-vscode.vscode-eslint"]="ESLint support"
    ["ms-python.black-formatter"]="Python Black formatter"
    ["ms-python.flake8"]="Python Flake8 linter"
    
    # Git & Version Control
    ["eamodio.gitlens"]="Git supercharged"
    ["GitLab.gitlab-workflow"]="GitLab integration"
    ["github.vscode-pull-request-github"]="GitHub integration"
    
    # Docker & DevOps
    ["ms-azuretools.vscode-docker"]="Docker support"
    ["ms-vscode-remote.remote-containers"]="Remote containers"
    ["ms-kubernetes-tools.vscode-kubernetes-tools"]="Kubernetes support"
    
    # Database
    ["ms-mssql.mssql"]="SQL Server support"
    ["cweijan.vscode-mysql-client2"]="MySQL client"
    ["cweijan.vscode-postgresql-client2"]="PostgreSQL client"
    ["cweijan.vscode-redis-client"]="Redis client"
    
    # Frontend Frameworks
    ["Vue.volar"]="Vue.js support"
    ["ms-vscode.vscode-typescript-next"]="React/JSX support"
    ["Angular.ng-template"]="Angular support"
    
    # Productivity & Utilities
    ["vscodevim.vim"]="Vim emulation"
    ["formulahendry.code-runner"]="Code runner"
    ["ms-vscode.live-server"]="Live server"
    ["ritwickdey.liveserver"]="Live server alternative"
    ["humao.rest-client"]="REST client"
    ["ms-vscode.hexeditor"]="Hex editor"
    
    # Themes & Icons
    ["zhuangtongfa.material-theme"]="One Dark Pro theme"
    ["vscode-icons-team.vscode-icons"]="VS Code icons"
    ["pkief.material-icon-theme"]="Material icon theme"
    
    # AI & Code Assistance
    ["github.copilot"]="GitHub Copilot"
    ["github.copilot-chat"]="GitHub Copilot Chat"
    
    # Snippets & Templates
    ["ms-vscode.vscode-snippet"]="Snippet support"
    ["formulahendry.auto-rename-tag"]="Auto rename tag"
    ["formulahendry.auto-close-tag"]="Auto close tag"
    
    # Documentation & Comments
    ["shd101wyy.markdown-preview-enhanced"]="Markdown preview"
    ["yzhang.markdown-all-in-one"]="Markdown all-in-one"
    ["aaron-bond.better-comments"]="Better comments"
    
    # Testing
    ["ms-vscode.test-adapter-converter"]="Test adapter"
    ["hbenl.vscode-test-explorer"]="Test explorer"
)

# WSL-specific extensions
declare -A wsl_extensions=(
    ["ms-vscode-remote.remote-wsl"]="Remote WSL support"
    ["ms-vscode-remote.remote-ssh"]="Remote SSH support"
    ["ms-vscode-remote.vscode-remote-extensionpack"]="Remote development extension pack"
)

# Add WSL extensions if running in WSL
if detect_wsl; then
    log_info "Adding WSL-specific extensions..."
    for ext_id in "${!wsl_extensions[@]}"; do
        extensions["$ext_id"]="${wsl_extensions[$ext_id]}"
    done
fi

# Additional useful extensions
extensions["alefragnani.bookmarks"]="Bookmarks"
extensions["gruntfuggly.todo-tree"]="TODO tree"
extensions["streetsidesoftware.code-spell-checker"]="Spell checker"

# Install extensions
total_extensions=${#extensions[@]}
current_extension=0

log_info "Installing $total_extensions extensions..."

for ext_id in "${!extensions[@]}"; do
    ((current_extension++))
    description="${extensions[$ext_id]}"
    log_info "[$current_extension/$total_extensions] Installing: $description ($ext_id)"
    
    if code --install-extension "$ext_id" --force > /dev/null 2>&1; then
        log_success "✅ $description"
    else
        log_warning "❌ Failed to install $description"
    fi
done

if detect_wsl; then
    log_success "Extension installation completed for WSL environment!"
    log_info "Note: Extensions are installed in the WSL context."
    log_info "Some extensions may also need to be installed on the Windows VS Code."
else
    log_success "Extension installation completed for Ubuntu!"
fi

log_info "Restart VS Code to activate all extensions."
