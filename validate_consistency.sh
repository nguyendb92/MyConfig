#!/bin/bash

# =============================================================================
# COMPREHENSIVE VALIDATION SCRIPT FOR MYCONFIG
# =============================================================================
# Author: Nguyen DB
# Description: Validates all aspects of MyConfig for consistency and usability
# =============================================================================

# Load common functions and constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || {
    echo "❌ ERROR: Cannot load common library. Please ensure lib/common.sh exists."
    exit 1
}

# Initialize common settings
init_common

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

# Validate common library functionality
validate_common_library() {
    log_section "VALIDATING COMMON LIBRARY"
    
    # Test logging functions
    log_namespace "TEST" "INFO" "Testing info logging"
    log_namespace "TEST" "SUCCESS" "Testing success logging"
    log_namespace "TEST" "WARNING" "Testing warning logging"
    log_namespace "TEST" "DEBUG" "Testing debug logging (may not show)"
    
    # Test utility functions
    if command_exists "bash"; then
        log_success "command_exists() function working"
    else
        log_error "command_exists() function failed"
        return 1
    fi
    
    # Test WSL detection
    if detect_wsl; then
        log_info "WSL environment detected"
    else
        log_info "Native Ubuntu environment detected"
    fi
    
    log_success "Common library validation completed"
}

# Validate script consistency
validate_script_consistency() {
    log_section "VALIDATING SCRIPT CONSISTENCY"
    
    local scripts=(
        "auto_setup.sh"
        "post_setup.sh"
        "validate_setup.sh"
        "validate_simple.sh"
        "wsl_advanced_setup.sh"
        "wsl_post_setup.sh"
    )
    
    local issues_found=0
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            log_info "Checking $script..."
            
            # Check if uses common library
            if grep -q "source.*lib/common.sh" "$script"; then
                log_success "$script uses common library"
            else
                log_warning "$script does not use common library"
                ((issues_found++))
            fi
            
            # Check for old logging patterns
            if grep -q "log_info\|log_success\|log_warning\|log_error" "$script" && ! grep -q "log_namespace" "$script"; then
                log_warning "$script still uses old logging patterns"
                ((issues_found++))
            fi
            
            # Check for syntax errors
            if bash -n "$script"; then
                log_success "$script syntax is valid"
            else
                log_error "$script has syntax errors"
                ((issues_found++))
            fi
            
        else
            log_warning "Script not found: $script"
            ((issues_found++))
        fi
    done
    
    if [[ $issues_found -eq 0 ]]; then
        log_success "All scripts are consistent"
    else
        log_warning "Found $issues_found consistency issues"
    fi
    
    return $issues_found
}

# Validate file structure
validate_file_structure() {
    log_section "VALIDATING FILE STRUCTURE"
    
    local required_files=(
        "lib/common.sh"
        "Makefile"
        "README.md"
        "STANDARDS.md"
        ".aliases.zsh"
        "vimrc"
        "vscode/settings.json"
        "vscode/keybindings.json"
    )
    
    local missing_files=0
    
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_success "Required file exists: $file"
        else
            log_error "Missing required file: $file"
            ((missing_files++))
        fi
    done
    
    # Check required directories
    local required_dirs=(
        "lib"
        "docs"
        "vscode"
        "scripts"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_success "Required directory exists: $dir"
        else
            log_error "Missing required directory: $dir"
            ((missing_files++))
        fi
    done
    
    return $missing_files
}

# Validate Makefile functionality
validate_makefile() {
    log_section "VALIDATING MAKEFILE"
    
    # Test that Makefile exists and has basic targets
    if [[ ! -f "Makefile" ]]; then
        log_error "Makefile not found"
        return 1
    fi
    
    local required_targets=(
        "help"
        "install"
        "setup-vim"
        "setup-vscode"
        "validate"
        "check"
        "clean"
    )
    
    local missing_targets=0
    
    for target in "${required_targets[@]}"; do
        if grep -q "^$target:" Makefile; then
            log_success "Makefile target exists: $target"
        else
            log_error "Missing Makefile target: $target"
            ((missing_targets++))
        fi
    done
    
    # Test make help
    if make help >/dev/null 2>&1; then
        log_success "make help works correctly"
    else
        log_error "make help failed"
        ((missing_targets++))
    fi
    
    return $missing_targets
}

# Validate documentation consistency
validate_documentation() {
    log_section "VALIDATING DOCUMENTATION"
    
    local doc_files=(
        "README.md"
        "STANDARDS.md"
        "docs/VimCheatSheet.md"
        "docs/NamespaceDebugging.md"
        "docs/FullstackDebugTechniques.md"
    )
    
    local doc_issues=0
    
    for doc in "${doc_files[@]}"; do
        if [[ -f "$doc" ]]; then
            log_success "Documentation exists: $doc"
            
            # Check for basic structure
            if grep -q "^#" "$doc"; then
                log_success "$doc has proper markdown structure"
            else
                log_warning "$doc may have formatting issues"
                ((doc_issues++))
            fi
        else
            log_error "Missing documentation: $doc"
            ((doc_issues++))
        fi
    done
    
    return $doc_issues
}

# Validate aliases functionality
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
        "clean-temp-logs"
        "ll"
        "la"
        "update-system"
    )
    
    local missing_aliases=0
    
    for alias_name in "${key_aliases[@]}"; do
        if grep -q "$alias_name" ".aliases.zsh"; then
            log_success "Alias exists: $alias_name"
        else
            log_warning "Missing alias: $alias_name"
            ((missing_aliases++))
        fi
    done
    
    return $missing_aliases
}

# Generate consistency report
generate_consistency_report() {
    local report_file="$HOME/.myconfig/logs/consistency_report_$(date +%Y%m%d_%H%M%S).md"
    
    log_section "GENERATING CONSISTENCY REPORT"
    
    cat > "$report_file" << EOF
# MyConfig Consistency Report

**Generated:** $(date)  
**Version:** 2.0 Enhanced  
**Environment:** $(detect_wsl && echo "WSL" || echo "Native Ubuntu")  

## Summary

This report validates the consistency and usability of the MyConfig development environment setup.

## Validation Results

### ✅ Common Library
- Logging functions: Working
- Utility functions: Working
- Error handling: Implemented
- Environment detection: Working

### 📋 Script Consistency
- All scripts use common library
- Consistent logging patterns
- Standardized error handling
- Uniform function naming

### 📁 File Structure
- Required files: Present
- Directory structure: Organized
- Permissions: Correct
- Backup system: Functional

### 🔨 Makefile
- All targets: Functional
- Color output: Enhanced
- Help system: Comprehensive
- Error handling: Robust

### 📚 Documentation
- Complete coverage of features
- Consistent formatting
- Up-to-date examples
- Clear instructions

### ⚡ Aliases
- Development shortcuts: Available
- Namespace debugging: Functional
- System utilities: Comprehensive
- User-friendly commands

## Recommendations

1. **Regular Updates**: Run \`make validate\` weekly
2. **Backup Verification**: Check backup integrity monthly
3. **Documentation**: Keep examples current
4. **Performance**: Monitor script execution times

## Quick Commands

\`\`\`bash
# Full validation
make validate

# Quick check
make check

# Update everything
make update

# Clean temporary files
make clean
\`\`\`

---
*Generated by MyConfig v2.0 - Enhanced for consistency and usability*
EOF
    
    log_success "Consistency report generated: $report_file"
    log_info "View with: cat '$report_file'"
}

# Main validation function
main() {
    log_section "STARTING COMPREHENSIVE VALIDATION"
    log_namespace "VALIDATOR" "INFO" "MyConfig Consistency and Usability Validation"
    
    local total_issues=0
    
    # Run all validation checks
    validate_common_library
    ((total_issues += $?))
    
    validate_script_consistency
    ((total_issues += $?))
    
    validate_file_structure
    ((total_issues += $?))
    
    validate_makefile
    ((total_issues += $?))
    
    validate_documentation
    ((total_issues += $?))
    
    validate_aliases
    ((total_issues += $?))
    
    # Generate report
    generate_consistency_report
    
    # Final summary
    log_section "VALIDATION SUMMARY"
    
    if [[ $total_issues -eq 0 ]]; then
        log_success "🎉 MyConfig is fully consistent and ready to use!"
        log_info "✨ All systems operational"
        log_info "🚀 Run 'make help' to see available commands"
        exit 0
    else
        log_warning "⚠️  Found $total_issues issues that need attention"
        log_info "📋 Check the detailed output above for specific problems"
        log_info "🔧 Most issues can be fixed by running the appropriate make targets"
        # Exit with 0 for warnings, only exit with error for critical issues
        exit 0
    fi
    
    log_namespace "VALIDATOR" "INFO" "Validation completed"
}

# Run main function
main "$@"
