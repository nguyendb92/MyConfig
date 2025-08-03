# MyConfig - Standard Configuration File
# This file defines consistent patterns used across all scripts

# =============================================================================
# FILE NAMING CONVENTIONS
# =============================================================================
# Scripts: snake_case.sh (e.g., auto_setup.sh, post_setup.sh)
# Functions: snake_case (e.g., install_dev_tools, configure_mysql)
# Variables: UPPERCASE for constants, lowercase for local vars
# Directories: kebab-case for user-facing, snake_case for internal

# =============================================================================
# LOGGING NAMESPACES - STANDARDIZED
# =============================================================================
# Core System Operations
NAMESPACE_SYSTEM="SYSTEM"      # System updates, package management
NAMESPACE_INSTALL="INSTALL"    # Software installation
NAMESPACE_CONFIG="CONFIG"      # Configuration management
NAMESPACE_VALIDATE="VALIDATE"  # Validation and checks

# Development Tools
NAMESPACE_GIT="GIT"           # Git configuration
NAMESPACE_VIM="VIM"           # Vim setup
NAMESPACE_VSCODE="VSCODE"     # VS Code setup
NAMESPACE_NODE="NODE"         # Node.js and npm
NAMESPACE_PYTHON="PYTHON"     # Python and pip
NAMESPACE_DOCKER="DOCKER"     # Docker setup

# Services
NAMESPACE_MYSQL="MYSQL"       # MySQL configuration
NAMESPACE_POSTGRES="POSTGRES" # PostgreSQL configuration  
NAMESPACE_REDIS="REDIS"       # Redis configuration

# Development Workflow
NAMESPACE_PROJECT="PROJECT"   # Project creation/management
NAMESPACE_BACKUP="BACKUP"     # Backup operations
NAMESPACE_CLEANUP="CLEANUP"   # Cleanup operations
NAMESPACE_DEBUG="DEBUG"       # Debug logging cleanup

# Environment Specific
NAMESPACE_WSL="WSL"           # WSL-specific operations
NAMESPACE_UBUNTU="UBUNTU"     # Ubuntu-specific operations

# =============================================================================
# FUNCTION NAMING PATTERNS
# =============================================================================
# Installation: install_<tool_name>()
# Configuration: configure_<service_name>() or setup_<tool_name>()
# Validation: validate_<component>() or check_<condition>()
# Utility: <action>_<object>() (e.g., backup_file, create_directory)

# =============================================================================
# ERROR HANDLING STANDARDS
# =============================================================================
# Always use set_error_trap() at script start
# Use safe_execute() for critical commands
# Use log_namespace() for consistent logging
# Include context in error messages

# =============================================================================
# DIRECTORY STRUCTURE STANDARDS
# =============================================================================
# $HOME/.myconfig/           - Main config directory
# $HOME/.myconfig/logs/      - Log files
# $HOME/.myconfig/backups/   - Backup files
# $HOME/Projects/            - Development projects
# $HOME/Projects/scripts/    - Custom scripts
# $HOME/Templates/           - Project templates

# =============================================================================
# FILE PERMISSIONS STANDARDS
# =============================================================================
# Scripts: 755 (executable)
# Config files: 644 (readable)
# Sensitive files: 600 (owner only)
# Directories: 755 (accessible)

# =============================================================================
# COLOR SCHEMES (via common.sh)
# =============================================================================
# Info: Blue with ℹ️
# Success: Green with ✅
# Warning: Yellow with ⚠️
# Error: Red with ❌
# Debug: Purple with 🐛
# Section: Purple with 🔧

# =============================================================================
# EXIT CODES STANDARDS
# =============================================================================
# 0: Success
# 1: General error
# 2: Misuse of shell command
# 126: Command cannot execute
# 127: Command not found
# 128+n: Fatal error signal "n"

# =============================================================================
# VALIDATION STANDARDS
# =============================================================================
# Always validate prerequisites before starting
# Check internet connectivity for downloads
# Verify disk space for installations
# Confirm user permissions before system changes

# =============================================================================
# BACKUP STANDARDS
# =============================================================================
# Always backup before modifying system files
# Use timestamp suffix: filename.backup_YYYYMMDD_HHMMSS
# Store backups in $HOME/.myconfig/backups/
# Include original path in backup metadata
