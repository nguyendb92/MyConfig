#!/bin/bash

# =============================================================================
# SIMPLE VALIDATION SCRIPT
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

# Check if command exists (simplified)
check_command() {
    local cmd=$1
    local name=$2
    
    if command -v "$cmd" &> /dev/null; then
        log_success "$name: Installed ✓"
        return 0
    else
        log_error "$name: Not installed ✗"
        return 1
    fi
}

# Detect environment
detect_environment() {
    log_section "ENVIRONMENT DETECTION"
    
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        log_info "Environment: WSL (Windows Subsystem for Linux)"
        return 0
    else
        log_info "Environment: Native Ubuntu"
        return 1
    fi
}

# Validate core tools
validate_core_tools() {
    log_section "CORE DEVELOPMENT TOOLS"
    
    local tools=(
        "git:Git"
        "vim:Vim"
        "curl:cURL"
        "wget:wget"
        "zsh:Zsh"
        "code:VS Code"
        "node:Node.js"
        "python3:Python 3"
        "docker:Docker"
    )
    
    local installed=0
    local total=${#tools[@]}
    
    for tool in "${tools[@]}"; do
        IFS=':' read -r cmd name <<< "$tool"
        if check_command "$cmd" "$name"; then
            ((installed++))
        fi
    done
    
    echo ""
    log_info "Core tools: $installed/$total installed"
}

# Validate services (simplified)
validate_services() {
    log_section "DEVELOPMENT SERVICES"
    
    local is_wsl=false
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        is_wsl=true
    fi
    
    local services=("mysql" "postgresql" "redis-server")
    
    for service in "${services[@]}"; do
        if $is_wsl; then
            if sudo service "$service" status >/dev/null 2>&1; then
                log_success "$service: Available (WSL service) ✓"
            else
                log_warning "$service: Not running (use 'sudo service $service start') ⚠️"
            fi
        else
            if systemctl is-active --quiet "$service" 2>/dev/null; then
                log_success "$service: Running (systemd) ✓"
            elif systemctl list-unit-files | grep -q "$service" 2>/dev/null; then
                log_warning "$service: Installed but not running ⚠️"
            else
                log_error "$service: Not installed ✗"
            fi
        fi
    done
}

# Validate configuration files
validate_configs() {
    log_section "CONFIGURATION FILES"
    
    local configs=(
        "$HOME/.vimrc:Vim configuration"
        "$HOME/.zshrc:Zsh configuration"
        "$HOME/.aliases.zsh:Aliases"
        "$HOME/.config/Code/User/settings.json:VS Code settings"
    )
    
    # Add WSL-specific config if in WSL
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        configs+=("$HOME/.wsl_dev_aliases.zsh:WSL development aliases")
    fi
    
    local found=0
    local total=${#configs[@]}
    
    for config in "${configs[@]}"; do
        IFS=':' read -r file desc <<< "$config"
        if [ -f "$file" ]; then
            log_success "$desc: Found ✓"
            ((found++))
        else
            log_warning "$desc: Not found ⚠️"
        fi
    done
    
    echo ""
    log_info "Configuration files: $found/$total found"
}

# Validate development directories
validate_directories() {
    log_section "DEVELOPMENT DIRECTORIES"
    
    local dirs=(
        "$HOME/Projects:Main project directory"
        "$HOME/Projects/frontend:Frontend projects"
        "$HOME/Projects/backend:Backend projects"
        "$HOME/Templates:Project templates"
        "$HOME/Scripts:Custom scripts"
    )
    
    local found=0
    local total=${#dirs[@]}
    
    for dir in "${dirs[@]}"; do
        IFS=':' read -r path desc <<< "$dir"
        if [ -d "$path" ]; then
            log_success "$desc: Found ✓"
            ((found++))
        else
            log_warning "$desc: Not found ⚠️"
        fi
    done
    
    echo ""
    log_info "Development directories: $found/$total found"
}

# Generate summary report
generate_summary() {
    log_section "VALIDATION SUMMARY"
    
    echo -e "${GREEN}✅ Environment validation completed!${NC}"
    echo ""
    echo "📊 Summary:"
    echo "  • Environment: $(detect_environment >/dev/null && echo 'WSL' || echo 'Native Ubuntu')"
    echo "  • Core tools: Checked"
    echo "  • Development services: Checked"
    echo "  • Configuration files: Verified"
    echo "  • Development directories: Confirmed"
    echo ""
    echo "💡 Next steps:"
    echo "  • Run 'make help' to see available commands"
    echo "  • Use 'make dev-start' to start development services"
    echo "  • Create your first project with 'make create-react PROJECT_NAME'"
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        echo "  • Run 'wsl-info' for WSL-specific information"
        echo "  • Use 'start-all-dev-services' to start services"
    fi
    echo ""
    echo "🆘 If you found issues:"
    echo "  • Run 'make check' for detailed diagnostics"
    echo "  • Check individual service status"
    echo "  • Review this validation output for warnings"
}

# Main execution
main() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║       MyConfig Environment Validation       ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    
    detect_environment
    validate_core_tools
    validate_services
    validate_configs
    validate_directories
    generate_summary
}

# Run main function
main "$@"
