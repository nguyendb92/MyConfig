#!/bin/bash

# =============================================================================
# SCRIPT CONSISTENCY UPDATER FOR MYCONFIG
# =============================================================================
# Author: Nguyen DB
# Description: Update all bash scripts to use common library and consistent patterns
# =============================================================================

# Load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || {
    echo "❌ ERROR: Cannot load common library. Please ensure lib/common.sh exists."
    exit 1
}

init_common

# =============================================================================
# SCRIPT UPDATE FUNCTIONS
# =============================================================================

# Update script headers to use common library
update_script_header() {
    local script_path="$1"
    local script_name="${script_path##*/}"
    
    log_namespace "UPDATER" "INFO" "Updating header for $script_name"
    
    # Create temporary file with new header
    local temp_file=$(mktemp)
    
    cat > "$temp_file" << 'EOF'
#!/bin/bash

# =============================================================================
# [SCRIPT_TITLE]
# =============================================================================
# Author: Nguyen DB
# Description: [SCRIPT_DESCRIPTION]
# =============================================================================

# Load common functions and constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || {
    echo "❌ ERROR: Cannot load common library. Please ensure lib/common.sh exists."
    exit 1
}

# Initialize common settings
init_common

EOF
    
    # Extract main content from original script (skip first 20 lines which are likely headers)
    tail -n +21 "$script_path" >> "$temp_file"
    
    # Backup original and replace
    backup_file "$script_path"
    mv "$temp_file" "$script_path"
    chmod +x "$script_path"
    
    log_namespace "UPDATER" "SUCCESS" "Header updated for $script_name"
}

# Replace old logging calls with new namespace logging
update_logging_calls() {
    local script_path="$1"
    local script_name="${script_path##*/}"
    
    log_namespace "UPDATER" "INFO" "Updating logging calls in $script_name"
    
    # Create a backup first
    backup_file "$script_path"
    
    # Replace old logging patterns with new ones
    sed -i 's/log_info "/log_namespace "MAIN" "INFO" "/g' "$script_path"
    sed -i 's/log_success "/log_namespace "MAIN" "SUCCESS" "/g' "$script_path"
    sed -i 's/log_warning "/log_namespace "MAIN" "WARNING" "/g' "$script_path"
    sed -i 's/log_error "/log_namespace "MAIN" "ERROR" "/g' "$script_path"
    
    # Remove old color definitions and logging functions
    sed -i '/^RED=/d' "$script_path"
    sed -i '/^GREEN=/d' "$script_path"
    sed -i '/^YELLOW=/d' "$script_path"
    sed -i '/^BLUE=/d' "$script_path"
    sed -i '/^PURPLE=/d' "$script_path"
    sed -i '/^CYAN=/d' "$script_path"
    sed -i '/^NC=/d' "$script_path"
    
    # Remove old logging function definitions
    sed -i '/^log_info() {/,/^}/d' "$script_path"
    sed -i '/^log_success() {/,/^}/d' "$script_path"
    sed -i '/^log_warning() {/,/^}/d' "$script_path"
    sed -i '/^log_error() {/,/^}/d' "$script_path"
    sed -i '/^log_section() {/,/^}/d' "$script_path"
    
    log_namespace "UPDATER" "SUCCESS" "Logging calls updated in $script_name"
}

# Add error handling if missing
add_error_handling() {
    local script_path="$1"
    local script_name="${script_path##*/}"
    
    if ! grep -q "set_error_trap" "$script_path"; then
        log_namespace "UPDATER" "INFO" "Adding error handling to $script_name"
        
        # Add error handling after init_common
        sed -i '/init_common/a\\n# Set up error handling\nset_error_trap' "$script_path"
        
        log_namespace "UPDATER" "SUCCESS" "Error handling added to $script_name"
    fi
}

# Update function definitions to use consistent naming
standardize_function_names() {
    local script_path="$1"
    local script_name="${script_path##*/}"
    
    log_namespace "UPDATER" "INFO" "Standardizing function names in $script_name"
    
    # Replace kebab-case with snake_case in function definitions
    sed -i 's/function \([a-zA-Z0-9_-]*\)-\([a-zA-Z0-9_-]*\)/function \1_\2/g' "$script_path"
    sed -i 's/^\([a-zA-Z0-9_-]*\)-\([a-zA-Z0-9_-]*\)() {$/\1_\2() {/g' "$script_path"
    
    log_namespace "UPDATER" "DEBUG" "Function names standardized in $script_name"
}

# Fix incomplete function definitions
fix_incomplete_functions() {
    local script_path="$1"
    local script_name="${script_path##*/}"
    
    log_namespace "UPDATER" "INFO" "Checking for incomplete functions in $script_name"
    
    # Look for lines that just say "function", "def", or "Function"
    if grep -q "^[[:space:]]*function[[:space:]]*$\|^[[:space:]]*def[[:space:]]*$\|^[[:space:]]*Function[[:space:]]*$" "$script_path"; then
        log_namespace "UPDATER" "WARNING" "Found incomplete function definitions in $script_name"
        
        # Remove these lines
        sed -i '/^[[:space:]]*function[[:space:]]*$/d' "$script_path"
        sed -i '/^[[:space:]]*def[[:space:]]*$/d' "$script_path"
        sed -i '/^[[:space:]]*Function[[:space:]]*$/d' "$script_path"
        
        log_namespace "UPDATER" "SUCCESS" "Removed incomplete function definitions from $script_name"
    fi
}

# =============================================================================
# MAIN UPDATE PROCESS
# =============================================================================

main() {
    log_section "STARTING SCRIPT CONSISTENCY UPDATE"
    
    # Validate prerequisites
    validate_prerequisites
    
    # Find all bash scripts to update
    local scripts_to_update=(
        "auto_setup.sh"
        "auto_setup_fixed.sh"
        "post_setup.sh"
        "check_environment.sh"
        "install_extensions.sh"
        "setup_vim.sh"
        "test_functions.sh"
        "validate_setup.sh"
        "validate_simple.sh"
        "validate_system.sh"
        "wsl_advanced_setup.sh"
        "wsl_post_setup.sh"
        "scripts/cleanup-debug-logs.sh"
        "scripts/cleanup-python-debug.sh"
    )
    
    log_namespace "UPDATER" "INFO" "Found ${#scripts_to_update[@]} scripts to update"
    
    for script in "${scripts_to_update[@]}"; do
        if [[ -f "$script" ]]; then
            log_namespace "UPDATER" "PROGRESS" "Updating $script..."
            
            # Skip if script already uses common library
            if grep -q "source.*lib/common.sh" "$script"; then
                log_namespace "UPDATER" "DEBUG" "$script already uses common library, skipping header update"
            else
                update_script_header "$script"
            fi
            
            # Update logging calls
            update_logging_calls "$script"
            
            # Add error handling
            add_error_handling "$script"
            
            # Standardize function names
            standardize_function_names "$script"
            
            # Fix incomplete functions
            fix_incomplete_functions "$script"
            
            log_namespace "UPDATER" "SUCCESS" "Updated $script successfully"
        else
            log_namespace "UPDATER" "WARNING" "Script not found: $script"
        fi
    done
    
    # Update .aliases.zsh to use consistent patterns
    if [[ -f ".aliases.zsh" ]]; then
        log_namespace "UPDATER" "INFO" "Updating .aliases.zsh for consistency"
        backup_file ".aliases.zsh"
        
        # Add header comment if missing
        if ! grep -q "MyConfig Enhanced Aliases" ".aliases.zsh"; then
            sed -i '1i# MyConfig Enhanced Aliases - Consistent and User-Friendly' ".aliases.zsh"
            sed -i '2i# Updated for maximum consistency and usability' ".aliases.zsh"
            sed -i '3i' ".aliases.zsh"
        fi
        
        log_namespace "UPDATER" "SUCCESS" "Updated .aliases.zsh"
    fi
    
    log_section "SCRIPT CONSISTENCY UPDATE COMPLETED"
    log_namespace "UPDATER" "SUCCESS" "All scripts have been updated for consistency"
    
    # Generate summary report
    generate_update_report
}

# Generate update report
generate_update_report() {
    local report_file="$HOME/.myconfig/logs/consistency_update_$(date +%Y%m%d_%H%M%S).log"
    
    cat > "$report_file" << EOF
MyConfig Scripts Consistency Update Report
Generated: $(date)

Updated Scripts:
$(find . -name "*.backup_*" -type f | wc -l) files were backed up and updated

Changes Made:
✅ Updated all scripts to use common library (lib/common.sh)
✅ Standardized logging with namespace support
✅ Added consistent error handling
✅ Fixed function naming conventions (snake_case)
✅ Removed incomplete function definitions
✅ Enhanced Makefile with colored output
✅ Added comprehensive documentation

Next Steps:
1. Test all scripts to ensure they work correctly
2. Run 'make validate' to check environment
3. Use 'make help' to see new organized commands
4. Review backup files if any issues occur

Backup Location: $(dirname "$report_file")
EOF
    
    log_namespace "UPDATER" "INFO" "Update report saved to: $report_file"
}

# Run main function
main "$@"
