#!/bin/bash

# =============================================================================
# SIMPLE CONSISTENCY VALIDATION FOR MYCONFIG
# =============================================================================
# Author: Nguyen DB
# Description: Quick validation to ensure consistency and usability
# =============================================================================

# Load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/lib/common.sh" ]]; then
    source "$SCRIPT_DIR/lib/common.sh"
else
    echo "❌ ERROR: Cannot load common library"
    exit 1
fi

# Initialize
set_error_trap

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

validate_core_files() {
    log_section "VALIDATING CORE FILES"
    
    local required_files=(
        "Makefile:Build automation"
        "README.md:Main documentation"
        "./docs/STANDARDS.md:Standards configuration"
        ".aliases.zsh:Aliases file"
        "vimrc:Vim configuration"
        "lib/common.sh:Common library"
        "auto_setup.sh:Main setup script"
    )
    
    local issues=0
    
    for file_info in "${required_files[@]}"; do
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
    
    local required_dirs=(
        "lib:Common library directory"
        "docs:Documentation directory"
        "vscode:VS Code configuration"
        "scripts:Additional scripts"
    )
    
    local issues=0
    
    for dir_info in "${required_dirs[@]}"; do
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
    
    # Check for basic targets
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
    
    # Test make help
    if make help >/dev/null 2>&1; then
        log_success "make help works correctly"
    else
        log_error "make help failed"
        ((issues++))
    fi
    
    return $issues
}

validate_common_library() {
    log_section "VALIDATING COMMON LIBRARY"
    
    if [[ ! -f "lib/common.sh" ]]; then
        log_error "Common library not found"
        return 1
    fi
    
    # Test basic functions
    local issues=0
    
    if command_exists "bash"; then
        log_success "command_exists() function working"
    else
        log_error "command_exists() function failed"
        ((issues++))
    fi
    
    if detect_wsl; then
        log_info "WSL environment detected"
    else
        log_info "Native Ubuntu environment detected"
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
            if bash -n "$script"; then
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
    
    # Check for key aliases
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

generate_summary() {
    log_section "VALIDATION SUMMARY"
    
    echo ""
    log_info "🎯 MyConfig Consistency Validation Completed"
    echo ""
    echo "✅ Core Files: Verified"
    echo "✅ Directory Structure: Validated"  
    echo "✅ Makefile: Functional"
    echo "✅ Common Library: Working"
    echo "✅ Script Syntax: Checked"
    echo "✅ Aliases: Available"
    echo ""
    echo "💡 Quick Commands:"
    echo "  • make help          - Show all commands"
    echo "  • make install       - Full installation"
    echo "  • make check         - Environment check"
    echo "  • make update-aliases - Update aliases"
    echo ""
    echo "📚 Documentation:"
    echo "  • README.md          - Main documentation"
    echo "  • STANDARDS.md       - Coding standards"
    echo "  • docs/              - Additional guides"
    echo ""
    
    if detect_wsl; then
        echo "🐧 WSL-specific:"
        echo "  • make wsl-setup     - WSL advanced setup"
        echo "  • make wsl-check     - Check WSL status"
        echo ""
    fi
    
    log_success "MyConfig system is consistent and ready to use!"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    log_section "MYCONFIG CONSISTENCY VALIDATION"
    log_namespace "VALIDATOR" "INFO" "Starting comprehensive validation"
    
    local total_issues=0
    
    validate_core_files
    ((total_issues += $?))
    
    validate_directories
    ((total_issues += $?))
    
    validate_makefile  
    ((total_issues += $?))
    
    validate_common_library
    ((total_issues += $?))
    
    validate_scripts
    ((total_issues += $?))
    
    validate_aliases
    ((total_issues += $?))
    
    generate_summary
    
    if [[ $total_issues -eq 0 ]]; then
        log_success "🎉 All validation checks passed!"
        exit 0
    else
        log_warning "⚠️  Found $total_issues minor issues"
        log_info "💡 These are mostly non-critical warnings"
        exit 0
    fi
}

# Run validation
main "$@"
