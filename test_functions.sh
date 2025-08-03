#!/bin/bash

# =============================================================================
# SCRIPT TEST FUNCTIONS CỦA AUTO_SETUP.SH
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Testing auto_setup.sh functions...${NC}"

# Source the main script to test functions
source auto_setup.sh 2>/dev/null || {
    echo -e "${RED}❌ Failed to source auto_setup.sh${NC}"
    exit 1
}

# Test function definitions
echo -e "\n${YELLOW}📋 Checking function definitions:${NC}"

functions_to_check=(
    "detect_wsl"
    "check_root" 
    "update_system"
    "install_dev_tools"
    "setup_git"
    "install_nodejs"
    "install_python"
    "install_docker"
    "install_databases"
    "install_vscode"
    "configure_vscode"
    "setup_vim"
    "setup_zsh"
    "install_additional_tools"
    "setup_dev_directories"
    "cleanup"
    "show_completion_info"
    "make_scripts_executable"
    "main"
)

missing_functions=()
found_functions=()

for func in "${functions_to_check[@]}"; do
    if declare -f "$func" > /dev/null; then
        echo -e "${GREEN}✅ $func${NC}"
        found_functions+=("$func")
    else
        echo -e "${RED}❌ $func${NC}"
        missing_functions+=("$func")
    fi
done

echo -e "\n${BLUE}📊 Test Summary:${NC}"
echo "Functions found: ${#found_functions[@]}/${#functions_to_check[@]}"

if [ ${#missing_functions[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 All functions are properly defined!${NC}"
else
    echo -e "${RED}❌ Missing functions:${NC}"
    for func in "${missing_functions[@]}"; do
        echo "  - $func"
    done
    exit 1
fi

# Test WSL detection function (safe to run)
echo -e "\n${YELLOW}🔍 Testing WSL detection:${NC}"
if detect_wsl; then
    echo -e "${GREEN}✅ WSL environment detected${NC}"
else
    echo -e "${BLUE}ℹ️  Native Ubuntu environment detected${NC}"
fi

# Test logging functions
echo -e "\n${YELLOW}🔍 Testing logging functions:${NC}"
log_info "Test info message"
log_success "Test success message"
log_warning "Test warning message"
log_error "Test error message"
log_section "TEST SECTION"

echo -e "\n${GREEN}🎉 All tests passed! auto_setup.sh is ready to use.${NC}"
echo -e "${BLUE}💡 To run the full setup: ./auto_setup.sh${NC}"
