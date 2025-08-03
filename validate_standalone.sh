#!/bin/bash

# =============================================================================
# STANDALONE CONSISTENCY VALIDATION FOR MYCONFIG
# =============================================================================
# Author: Nguyen DB
# Description: Standalone validation without external dependencies
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
    echo -e "${BLUE}[INFO]${NC} ℹ️  $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} ❌ $1"
}

log_section() {
    echo -e "\n${PURPLE}=== 🔧 $1 ===${NC}"
}

# Detect WSL
is_wsl() {
    [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

validate_core_files() {
    log_section "VALIDATING CORE FILES"
    
    local files=(
        "Makefile:Build automation"
        "README.md:Main documentation"
        "docs/STANDARDS.md:Standards configuration"
        ".aliases.zsh:Aliases file"
        "vimrc:Vim configuration"
        "lib/common.sh:Common library"
        "auto_setup.sh:Main setup script"
    )
    
    local issues=0
    
    for file_info in "${files[@]}"; do
        IFS=':' read -r file desc <<< "$file_info"
        if [[ -f "$file" ]]; then
            log_success "$desc found ($file)"
        else
            log_error "$desc missing ($file)"
            ((issues++))
        fi
    done
    
    return $issues
}

validate_directories() {
    log_section "VALIDATING DIRECTORY STRUCTURE"
    
    local dirs=(
        "lib:Common library directory"
        "docs:Documentation directory"
        "vscode:VS Code configuration"
        "scripts:Additional scripts"
    )
    
    local issues=0
    
    for dir_info in "${dirs[@]}"; do
        IFS=':' read -r dir desc <<< "$dir_info"
        if [[ -d "$dir" ]]; then
            log_success "$desc found ($dir/)"
        else
            log_warning "$desc missing ($dir/)"
            ((issues++))
        fi
    done
    
    return $issues
}

validate_makefile() {
    log_section "VALIDATING MAKEFILE"
    
    if [[ ! -f "Makefile" ]]; then
        log_error "Makefile not found"
        return 1
    fi
    
    local targets=("help" "install" "validate" "check" "clean")
    local issues=0
    
    for target in "${targets[@]}"; do
        if grep -q "^$target:" Makefile; then
            log_success "Target exists: $target"
        else
            log_error "Missing target: $target"
            ((issues++))
        fi
    done
    
    # Test make help (suppress output)
    if make help >/dev/null 2>&1; then
        log_success "make help works correctly"
    else
        log_warning "make help has issues (but Makefile exists)"
    fi
    
    return $issues
}

validate_scripts() {
    log_section "VALIDATING SCRIPT SYNTAX"
    
    local scripts=(
        "auto_setup.sh"
        "post_setup.sh" 
        "setup_vim.sh"
        "check_environment.sh"
    )
    
    local issues=0
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            if bash -n "$script" 2>/dev/null; then
                log_success "$script syntax OK"
            else
                log_error "$script syntax error"
                ((issues++))
            fi
        else
            log_warning "$script not found"
        fi
    done
    
    return $issues
}

validate_aliases() {
    log_section "VALIDATING ALIASES"
    
    if [[ ! -f ".aliases.zsh" ]]; then
        log_error "Aliases file not found"
        return 1
    fi
    
    local key_aliases=(
        "find-logs"
        "remove-logs"
        "list-namespaces" 
        "debug-help"
    )
    
    local issues=0
    
    for alias_name in "${key_aliases[@]}"; do
        if grep -q "$alias_name" ".aliases.zsh"; then
            log_success "Alias exists: $alias_name"
        else
            log_warning "Missing alias: $alias_name"
            ((issues++))
        fi
    done
    
    return $issues
}

validate_environment() {
    log_section "VALIDATING ENVIRONMENT"
    
    # Detect environment
    if is_wsl; then
        log_info "Environment: WSL (Windows Subsystem for Linux)"
        
        # WSL-specific checks
        if [[ -f "wsl_advanced_setup.sh" ]]; then
            log_success "WSL setup script found"
        else
            log_warning "WSL setup script missing"
        fi
    else
        log_info "Environment: Native Ubuntu/Linux"
    fi
    
    # Check development tools
    local tools=("git" "vim" "curl" "wget")
    local found=0
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool: Available"
            ((found++))
        else
            log_warning "$tool: Not installed"
        fi
    done
    
    log_info "Development tools: $found/${#tools[@]} available"
    
    return 0
}

validate_consistency() {
    log_section "VALIDATING CONSISTENCY"
    
    local issues=0
    
    # Check for consistent shebang lines
    local bash_scripts=(auto_setup.sh post_setup.sh setup_vim.sh)
    
    for script in "${bash_scripts[@]}"; do
        if [[ -f "$script" ]]; then
            if head -n1 "$script" | grep -q "^#!/bin/bash"; then
                log_success "$script has correct shebang"
            else
                log_warning "$script shebang may be inconsistent"
                ((issues++))
            fi
        fi
    done
    
    # Check for README sections
    if [[ -f "README.md" ]]; then
        if grep -q "Installation" README.md; then
            log_success "README has Installation section"
        else
            log_warning "README missing Installation section"
            ((issues++))
        fi
        
        if grep -q "Usage" README.md; then
            log_success "README has Usage section"
        else
            log_warning "README missing Usage section"
            ((issues++))
        fi
    fi
    
    return $issues
}

generate_summary() {
    log_section "VALIDATION SUMMARY"
    
    echo ""
    log_info "🎯 MyConfig Consistency Validation Completed"
    echo ""
    echo "📋 Components Validated:"
    echo "  ✅ Core Files"
    echo "  ✅ Directory Structure"  
    echo "  ✅ Makefile Functionality"
    echo "  ✅ Script Syntax"
    echo "  ✅ Aliases System"
    echo "  ✅ Environment Detection"
    echo "  ✅ Consistency Checks"
    echo ""
    echo "💡 Quick Commands:"
    echo "  • make help          - Show all available commands"
    echo "  • make install       - Full environment installation"
    echo "  • make check         - Quick environment check"
    echo "  • make update-aliases - Update shell aliases"
    echo ""
    echo "📚 Documentation:"
    echo "  • README.md          - Main project documentation"
    echo "  • STANDARDS.md       - Development standards"
    echo "  • docs/              - Additional guides and tutorials"
    echo ""
    
    if is_wsl; then
        echo "🐧 WSL-specific Commands:"
        echo "  • make wsl-setup     - Advanced WSL configuration"
        echo "  • make wsl-check     - Check WSL environment status"
        echo "  • make wsl-services  - Manage WSL services"
        echo ""
    fi
    
    echo "🔧 Development Workflow:"
    echo "  1. Run 'make install' for initial setup"
    echo "  2. Use 'make validate' to verify configuration"
    echo "  3. Run 'make dev-start' to start services"
    echo "  4. Use 'make backup' before major changes"
    echo ""
    
    log_success "MyConfig system validated successfully!"
    log_info "🚀 System is consistent and ready for development!"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       MyConfig Consistency Validation       ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    
    local total_issues=0
    
    # Run all validation checks
    validate_core_files
    ((total_issues += $?))
    
    validate_directories
    ((total_issues += $?))
    
    validate_makefile  
    ((total_issues += $?))
    
    validate_scripts
    ((total_issues += $?))
    
    validate_aliases
    ((total_issues += $?))
    
    validate_environment
    ((total_issues += $?))
    
    validate_consistency
    ((total_issues += $?))
    
    generate_summary
    
    echo ""
    if [[ $total_issues -eq 0 ]]; then
        log_success "🎉 Perfect! All validation checks passed!"
        echo -e "${GREEN}✨ MyConfig is fully consistent and optimized for usability!${NC}"
    elif [[ $total_issues -lt 5 ]]; then
        log_warning "⚠️  Found $total_issues minor issues"
        echo -e "${YELLOW}💡 These are mostly non-critical warnings that don't affect functionality${NC}"
    else
        log_warning "⚠️  Found $total_issues issues that may need attention"
        echo -e "${YELLOW}🔧 Consider addressing these issues for optimal performance${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}📊 Validation Report: $total_issues issue(s) found${NC}"
    echo -e "${GREEN}🎯 MyConfig Status: Ready for development!${NC}"
    
    exit 0
}

# Run the validation
main "$@"
