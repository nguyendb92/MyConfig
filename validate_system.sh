#!/bin/bash

# ============================================================================
# MyConfig System Validation Script
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validation functions
check_core_files() {
    print_header "Core Files Validation"
    
    local files=(
        "auto_setup.sh:Main setup script"
        ".aliases.zsh:Aliases configuration" 
        "vimrc:Vim configuration"
        "Makefile:Build automation"
        "./docs/LICENSE:.docs/License file"
    )
    
    for file_info in "${files[@]}"; do
        IFS=':' read -r file desc <<< "$file_info"
        if [ -f "$file" ]; then
            print_success "$desc found ($file)"
        else
            print_error "$desc missing ($file)"
        fi
    done
}

check_directories() {
    print_header "Directory Structure Validation"
    
    local dirs=(
        "vscode:VS Code configurations"
        "docs:Documentation"
    )
    
    for dir_info in "${dirs[@]}"; do
        IFS=':' read -r dir desc <<< "$dir_info"
        if [ -d "$dir" ]; then
            print_success "$desc found ($dir/)"
        else
            print_error "$desc missing ($dir/)"
        fi
    done
}

check_documentation() {
    print_header "Documentation Validation"
    
    local docs=(
        "docs/index.md:Documentation index"
        "docs/NamespaceDebugging.md:Namespace debugging guide"
        "docs/VimCheatSheet.md:Vim cheat sheet"
        "docs/FullstackDebugTechniques.md:Fullstack debugging guide"
        "README.md:Main README"
    )
    
    for doc_info in "${docs[@]}"; do
        IFS=':' read -r doc desc <<< "$doc_info"
        if [ -f "$doc" ]; then
            print_success "$desc found ($doc)"
        else
            print_error "$desc missing ($doc)"
        fi
    done
}

check_installed_aliases() {
    print_header "Aliases Installation Check"
    
    if [ -f "$HOME/.aliases.zsh" ]; then
        print_success "Aliases installed in home directory"
        
        # Check if sourced in .zshrc
        if [ -f "$HOME/.zshrc" ] && grep -q "source.*aliases.zsh" "$HOME/.zshrc"; then
            print_success "Aliases sourced in .zshrc"
        else
            print_warning "Aliases not sourced in .zshrc"
            print_info "Add this line to ~/.zshrc: source ~/.aliases.zsh"
        fi
    else
        print_error "Aliases not installed - run 'make update-aliases'"
    fi
}

check_namespace_functions() {
    print_header "Namespace Debug Functions Validation"
    
    if [ -f ".aliases.zsh" ]; then
        local functions=(
            "find-logs"
            "count-logs" 
            "remove-logs-dry"
            "remove-logs"
            "list-namespaces"
            "debug-help"
        )
        
        for func in "${functions[@]}"; do
            if grep -q "^$func()" .aliases.zsh; then
                print_success "Function $func found"
            else
                print_error "Function $func missing"
            fi
        done
        
    else
        print_error "Cannot validate functions - .aliases.zsh not found"
    fi
}

check_system_tools() {
    print_header "System Tools Check"
    
    local tools=(
        "git:Git version control"
        "vim:Vim editor"
        "curl:HTTP client"
        "docker:Container platform"
        "node:Node.js runtime"
        "python3:Python interpreter"
    )
    
    for tool_info in "${tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_info"
        if command_exists "$tool"; then
            local version=$($tool --version 2>/dev/null | head -n1)
            print_success "$desc available ($version)"
        else
            print_warning "$desc not found"
        fi
    done
}

check_vscode_integration() {
    print_header "VS Code Integration Check"
    
    local vscode_config="$HOME/.config/Code/User"
    if [ -d "$vscode_config" ]; then
        print_success "VS Code config directory found"
        
        if [ -f "$vscode_config/settings.json" ]; then
            print_success "VS Code settings.json found"
        else
            print_warning "VS Code settings.json not found"
        fi
        
        if [ -f "$vscode_config/keybindings.json" ]; then
            print_success "VS Code keybindings.json found"
        else
            print_warning "VS Code keybindings.json not found"
        fi
    else
        print_warning "VS Code config directory not found"
    fi
}

check_syntax() {
    print_header "Syntax Validation"
    
    # Check shell scripts syntax
    local scripts=("auto_setup.sh" "setup_vim.sh" "post_setup.sh")
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if bash -n "$script" 2>/dev/null; then
                print_success "$script syntax OK"
            else
                print_error "$script syntax error"
            fi
        fi
    done
    
    # Check aliases syntax
    if [ -f ".aliases.zsh" ]; then
        if zsh -n .aliases.zsh 2>/dev/null; then
            print_success ".aliases.zsh syntax OK"
        else
            print_error ".aliases.zsh syntax error"
        fi
    fi
}

run_namespace_test() {
    print_header "Namespace System Functional Test"
    
    if [ -f "$HOME/.aliases.zsh" ]; then
        print_info "Testing namespace functions..."
        
        # Source aliases temporarily for testing
        source "$HOME/.aliases.zsh" 2>/dev/null
        
        # Test if functions are callable
        if declare -f find-logs >/dev/null; then
            print_success "find-logs function is callable"
        else
            print_error "find-logs function not callable"
        fi
    else
        print_warning "Cannot test functions - aliases not installed"
    fi
}

generate_report() {
    print_header "Validation Summary"
    
    local total_checks=0
    local passed_checks=0
    
    # Count total output lines with ✅ and ❌
    total_checks=$(grep -c "✅\|❌" /tmp/validation_output.log 2>/dev/null || echo "0")
    passed_checks=$(grep -c "✅" /tmp/validation_output.log 2>/dev/null || echo "0")
    
    local failed_checks=$((total_checks - passed_checks))
    
    echo "📊 Validation Results:"
    echo "   Total checks: $total_checks"
    echo "   Passed: $passed_checks"
    echo "   Failed: $failed_checks"
    
    if [ $failed_checks -eq 0 ]; then
        print_success "All validations passed! 🎉"
    else
        print_warning "$failed_checks issues found. Check output above for details."
    fi
    
    echo ""
    print_info "To fix common issues:"
    echo "   - Run 'make update-aliases' to install aliases"
    echo "   - Run 'make setup-vscode' to setup VS Code"
    echo "   - Run 'make install' for full setup"
}

# Main execution
main() {
    echo "🔍 MyConfig System Validation"
    echo "============================="
    
    # Redirect output to temp file for analysis
    exec > >(tee /tmp/validation_output.log)
    
    check_core_files
    check_directories  
    check_documentation
    check_installed_aliases
    check_namespace_functions
    check_system_tools
    check_vscode_integration
    check_syntax
    run_namespace_test
    generate_report
    
    # Cleanup
    rm -f /tmp/validation_output.log
}

# Run main function
main "$@"
