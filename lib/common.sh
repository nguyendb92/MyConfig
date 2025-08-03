#!/bin/bash

# =============================================================================
# COMMON LIBRARY FOR MYCONFIG SCRIPTS
# =============================================================================
# Author: Nguyen DB
# Description: Shared functions, logging, and error handling for all scripts
# Usage: source lib/common.sh
# =============================================================================

# Exit on any error
set -e

# Color constants for consistent output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Emoji constants for better UX
readonly EMOJI_INFO="ℹ️ "
readonly EMOJI_SUCCESS="✅"
readonly EMOJI_WARNING="⚠️ "
readonly EMOJI_ERROR="❌"
readonly EMOJI_DEBUG="🐛"
readonly EMOJI_SECTION="🔧"
readonly EMOJI_PROGRESS="⚡"

# =============================================================================
# LOGGING FUNCTIONS - STANDARDIZED ACROSS ALL SCRIPTS
# =============================================================================

# Standard logging functions with consistent format
log_info() {
    echo -e "${BLUE}[INFO]${NC} ${EMOJI_INFO}$1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} ${EMOJI_SUCCESS} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} ${EMOJI_WARNING}$1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} ${EMOJI_ERROR} $1"
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${PURPLE}[DEBUG]${NC} ${EMOJI_DEBUG} $1"
    fi
}

log_section() {
    echo -e "\n${PURPLE}=== ${EMOJI_SECTION} $1 ===${NC}"
}

log_progress() {
    echo -e "${CYAN}[PROGRESS]${NC} ${EMOJI_PROGRESS} $1"
}

# Enhanced logging with namespace support
log_namespace() {
    local namespace="$1"
    local level="$2"
    local message="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "DEBUG") 
            [[ "${DEBUG:-false}" == "true" ]] && echo -e "${PURPLE}[$timestamp] [${namespace}:DEBUG]${NC} ${EMOJI_DEBUG} $message"
            ;;
        "INFO") 
            echo -e "${BLUE}[$timestamp] [${namespace}:INFO]${NC} ${EMOJI_INFO}$message"
            ;;
        "SUCCESS") 
            echo -e "${GREEN}[$timestamp] [${namespace}:SUCCESS]${NC} ${EMOJI_SUCCESS} $message"
            ;;
        "WARNING") 
            echo -e "${YELLOW}[$timestamp] [${namespace}:WARNING]${NC} ${EMOJI_WARNING}$message"
            ;;
        "ERROR") 
            echo -e "${RED}[$timestamp] [${namespace}:ERROR]${NC} ${EMOJI_ERROR} $message"
            ;;
    esac
}

# =============================================================================
# ERROR HANDLING FUNCTIONS
# =============================================================================

# Enhanced error handling with context
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command="$2"
    local script_name="${BASH_SOURCE[1]##*/}"
    
    log_error "Script failed in $script_name at line $line_number"
    log_error "Command: $command"
    log_error "Exit code: $exit_code"
    
    # Optional: send to monitoring/logging service
    if [[ -n "${LOG_SERVICE_URL:-}" ]]; then
        send_error_to_service "$script_name" "$line_number" "$command" "$exit_code"
    fi
    
    exit $exit_code
}

# Set trap for error handling
set_error_trap() {
    trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR
}

# Safe command execution with retry
safe_execute() {
    local max_attempts=${2:-3}
    local delay=${3:-2}
    local command="$1"
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log_debug "Executing: $command (attempt $attempt/$max_attempts)"
        
        if eval "$command"; then
            log_debug "Command succeeded on attempt $attempt"
            return 0
        else
            local exit_code=$?
            if [ $attempt -eq $max_attempts ]; then
                log_error "Command failed after $max_attempts attempts: $command"
                return $exit_code
            else
                log_warning "Command failed (attempt $attempt/$max_attempts), retrying in ${delay}s..."
                sleep $delay
            fi
        fi
        ((attempt++))
    done
}

# =============================================================================
# ENVIRONMENT DETECTION FUNCTIONS
# =============================================================================

# Detect WSL environment
detect_wsl() {
    if [[ -f /proc/version ]] && grep -qi "microsoft\|wsl" /proc/version; then
        return 0
    elif [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
        return 0
    elif [[ $(uname -r) =~ Microsoft|microsoft|WSL|wsl ]]; then
        return 0
    else
        return 1
    fi
}

# Detect OS distribution
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if package is installed (Ubuntu/Debian)
package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

# Check if service is running
service_running() {
    local service_name="$1"
    
    if detect_wsl; then
        # WSL uses service command
        sudo service "$service_name" status >/dev/null 2>&1
    else
        # Native Ubuntu uses systemctl
        systemctl is-active --quiet "$service_name"
    fi
}

# Start service with WSL/Native compatibility
start_service() {
    local service_name="$1"
    
    if detect_wsl; then
        log_info "Starting $service_name (WSL mode)"
        safe_execute "sudo service $service_name start"
    else
        log_info "Starting $service_name (systemctl mode)"
        safe_execute "sudo systemctl start $service_name"
        safe_execute "sudo systemctl enable $service_name"
    fi
}

# Stop service with WSL/Native compatibility
stop_service() {
    local service_name="$1"
    
    if detect_wsl; then
        log_info "Stopping $service_name (WSL mode)"
        safe_execute "sudo service $service_name stop"
    else
        log_info "Stopping $service_name (systemctl mode)"
        safe_execute "sudo systemctl stop $service_name"
    fi
}

# =============================================================================
# FILE AND DIRECTORY FUNCTIONS
# =============================================================================

# Create directory with error handling
safe_mkdir() {
    local dir_path="$1"
    local mode="${2:-755}"
    
    if [[ ! -d "$dir_path" ]]; then
        log_debug "Creating directory: $dir_path"
        mkdir -p "$dir_path"
        chmod "$mode" "$dir_path"
        log_debug "Directory created successfully"
    else
        log_debug "Directory already exists: $dir_path"
    fi
}

# Backup file before modification
backup_file() {
    local file_path="$1"
    local backup_suffix="${2:-$(date +%Y%m%d_%H%M%S)}"
    
    if [[ -f "$file_path" ]]; then
        local backup_path="${file_path}.backup_${backup_suffix}"
        log_debug "Backing up $file_path to $backup_path"
        cp "$file_path" "$backup_path"
        log_debug "Backup created successfully"
        echo "$backup_path"
    fi
}

# Download file with progress and verification
safe_download() {
    local url="$1"
    local output_path="$2"
    local expected_checksum="${3:-}"
    
    log_progress "Downloading: $url"
    
    if command_exists wget; then
        safe_execute "wget -O '$output_path' '$url'"
    elif command_exists curl; then
        safe_execute "curl -L -o '$output_path' '$url'"
    else
        log_error "Neither wget nor curl is available"
        return 1
    fi
    
    # Verify checksum if provided
    if [[ -n "$expected_checksum" ]]; then
        local actual_checksum=$(sha256sum "$output_path" | cut -d' ' -f1)
        if [[ "$actual_checksum" != "$expected_checksum" ]]; then
            log_error "Checksum verification failed for $output_path"
            rm -f "$output_path"
            return 1
        fi
        log_success "Checksum verified successfully"
    fi
    
    log_success "Download completed: $output_path"
}

# =============================================================================
# CONFIGURATION FUNCTIONS
# =============================================================================

# Add line to file if not exists
add_line_to_file() {
    local line="$1"
    local file_path="$2"
    local backup="${3:-true}"
    
    if [[ ! -f "$file_path" ]]; then
        log_debug "Creating new file: $file_path"
        echo "$line" > "$file_path"
        return 0
    fi
    
    if ! grep -Fxq "$line" "$file_path"; then
        if [[ "$backup" == "true" ]]; then
            backup_file "$file_path"
        fi
        
        log_debug "Adding line to $file_path: $line"
        echo "$line" >> "$file_path"
        log_debug "Line added successfully"
    else
        log_debug "Line already exists in $file_path"
    fi
}

# Update or add key-value pair in config file
update_config_value() {
    local key="$1"
    local value="$2"
    local file_path="$3"
    local separator="${4:-=}"
    local backup="${5:-true}"
    
    if [[ "$backup" == "true" ]]; then
        backup_file "$file_path"
    fi
    
    if grep -q "^${key}${separator}" "$file_path" 2>/dev/null; then
        # Update existing key
        log_debug "Updating $key in $file_path"
        sed -i "s|^${key}${separator}.*|${key}${separator}${value}|" "$file_path"
    else
        # Add new key
        log_debug "Adding $key to $file_path"
        echo "${key}${separator}${value}" >> "$file_path"
    fi
}

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

# Validate script prerequisites
validate_prerequisites() {
    local script_name="${1:-${BASH_SOURCE[1]##*/}}"
    
    log_section "VALIDATING PREREQUISITES FOR $script_name"
    
    # Check if running as root
    check_root
    
    # Check internet connectivity
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        log_warning "No internet connectivity detected"
    else
        log_success "Internet connectivity verified"
    fi
    
    # Check available disk space (minimum 1GB)
    local available_space=$(df / | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 1048576 ]]; then # 1GB in KB
        log_warning "Low disk space detected: $(($available_space / 1024))MB available"
    else
        log_success "Sufficient disk space available"
    fi
    
    log_success "Prerequisites validation completed"
}

# =============================================================================
# SCRIPT INITIALIZATION
# =============================================================================

# Initialize common settings
init_common() {
    # Set error trap
    set_error_trap
    
    # Set debug mode if DEBUG environment variable is set
    if [[ "${DEBUG:-false}" == "true" ]]; then
        log_debug "Debug mode enabled"
        set -x
    fi
    
    # Create common directories
    safe_mkdir "$HOME/.myconfig" 755
    safe_mkdir "$HOME/.myconfig/logs" 755
    safe_mkdir "$HOME/.myconfig/backups" 755
    
    # Log script start
    local script_name="${BASH_SOURCE[1]##*/}"
    log_namespace "SYSTEM" "INFO" "Starting $script_name"
}

# =============================================================================
# EXPORT FUNCTIONS FOR USE IN OTHER SCRIPTS
# =============================================================================

# Only export if not already exported
if [[ -z "${MYCONFIG_COMMON_LOADED:-}" ]]; then
    export MYCONFIG_COMMON_LOADED=true
    log_debug "Common library loaded successfully"
fi
