#!/bin/bash

# =============================================================================
# DEBUG LOG CLEANUP SCRIPT - NAMESPACE BASED
# =============================================================================
# Author: Nguyen DB
# Description: Remove namespace debug logs from JavaScript/TypeScript files
# Usage: ./cleanup-debug-logs.sh [dry-run|cleanup] <namespace> [directory]
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Available namespaces
NAMESPACES=("API-DEBUG" "UI-DEBUG" "AUTH-DEBUG" "DB-DEBUG" "PERF-DEBUG" "WS-DEBUG" "VALID-DEBUG" "TEMP-DEBUG")

# Function to show what will be removed (dry run)
dry_run_cleanup() {
    local namespace=$1
    local directory=${2:-.}
    
    echo -e "${BLUE}🔍 DRY RUN - Searching for ${namespace} logs in: ${directory}${NC}"
    echo ""
    
    # Find all JavaScript/TypeScript files
    local files=$(find "$directory" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    
    local total_matches=0
    local file_count=0
    
    for file in $files; do
        # Count matches for this namespace
        local matches=$(grep -n "\[${namespace}\]" "$file" 2>/dev/null | wc -l)
        
        if [ "$matches" -gt 0 ]; then
            file_count=$((file_count + 1))
            echo -e "${YELLOW}📄 File: ${file}${NC}"
            echo -e "   ${GREEN}Found ${matches} log(s) with namespace [${namespace}]${NC}"
            
            # Show the actual lines that would be removed
            grep -n "\[${namespace}\]" "$file" 2>/dev/null | head -5 | while read -r line; do
                echo -e "   ${RED}Line:${NC} $line"
            done
            
            if [ "$matches" -gt 5 ]; then
                echo -e "   ${PURPLE}... and $((matches - 5)) more lines${NC}"
            fi
            echo ""
            
            total_matches=$((total_matches + matches))
        fi
    done
    
    echo -e "${BLUE}📊 Summary:${NC}"
    echo -e "   Files affected: ${file_count}"
    echo -e "   Total log statements: ${total_matches}"
    echo ""
    
    if [ "$total_matches" -gt 0 ]; then
        echo -e "${YELLOW}💡 To actually remove these logs, run:${NC}"
        echo -e "   $0 cleanup $namespace $directory"
    else
        echo -e "${GREEN}✅ No logs found with namespace [${namespace}]${NC}"
    fi
}

# Function to actually remove the logs
cleanup_namespace_logs() {
    local namespace=$1
    local directory=${2:-.}
    
    echo -e "${BLUE}🧹 Cleaning up ${namespace} logs in: ${directory}${NC}"
    echo ""
    
    # Find all JavaScript/TypeScript files
    local files=$(find "$directory" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    
    local total_removed=0
    local files_modified=0
    
    for file in $files; do
        # Count existing matches
        local matches=$(grep -c "\[${namespace}\]" "$file" 2>/dev/null || echo "0")
        
        if [ "$matches" -gt 0 ]; then
            # Create backup
            cp "$file" "${file}.backup"
            
            # Remove lines containing the namespace
            sed -i "/\[${namespace}\]/d" "$file"
            
            # Remove empty console.log() calls
            sed -i '/^[[:space:]]*console\.log()[[:space:]]*;*[[:space:]]*$/d' "$file"
            
            # Remove empty log calls
            sed -i '/^[[:space:]]*log\.[a-zA-Z]*()[[:space:]]*;*[[:space:]]*$/d' "$file"
            
            # Remove empty colorLog calls
            sed -i '/^[[:space:]]*colorLog\.[a-zA-Z]*()[[:space:]]*;*[[:space:]]*$/d' "$file"
            
            echo -e "${GREEN}✅ Cleaned ${matches} log(s) from: ${file}${NC}"
            total_removed=$((total_removed + matches))
            files_modified=$((files_modified + 1))
        fi
    done
    
    echo ""
    echo -e "${GREEN}🎉 Cleanup completed!${NC}"
    echo -e "   Files modified: ${files_modified}"
    echo -e "   Log statements removed: ${total_removed}"
    echo -e "${YELLOW}💡 Backup files created with .backup extension${NC}"
    echo -e "${BLUE}   Use '$0 restore $directory' to undo changes${NC}"
}

# Function to restore from backups
restore_backups() {
    local directory=${1:-.}
    
    echo -e "${BLUE}🔄 Restoring from backup files in: ${directory}${NC}"
    echo ""
    
    local backups=$(find "$directory" -name "*.backup" ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    local restored_count=0
    
    for backup in $backups; do
        local original="${backup%.backup}"
        mv "$backup" "$original"
        echo -e "${GREEN}✅ Restored: ${original}${NC}"
        restored_count=$((restored_count + 1))
    done
    
    if [ "$restored_count" -gt 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 Restored ${restored_count} files from backups!${NC}"
    else
        echo -e "${YELLOW}⚠️  No backup files found${NC}"
    fi
}

# Function to remove backup files
remove_backups() {
    local directory=${1:-.}
    
    echo -e "${BLUE}🗑️  Removing backup files in: ${directory}${NC}"
    echo ""
    
    local backups=$(find "$directory" -name "*.backup" ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    local removed_count=0
    
    for backup in $backups; do
        rm "$backup"
        echo -e "${GREEN}✅ Removed backup: ${backup}${NC}"
        removed_count=$((removed_count + 1))
    done
    
    if [ "$removed_count" -gt 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 Removed ${removed_count} backup files!${NC}"
    else
        echo -e "${YELLOW}⚠️  No backup files found${NC}"
    fi
}

# Show available namespaces
show_namespaces() {
    echo -e "${BLUE}📋 Available namespaces:${NC}"
    for i in "${!NAMESPACES[@]}"; do
        echo -e "  ${YELLOW}$((i+1)).${NC} ${NAMESPACES[$i]}"
    done
    echo ""
}

# Show usage
show_usage() {
    echo -e "${BLUE}🧹 Debug Log Cleanup Tool${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 dry-run <namespace> [directory]     - Show what would be removed"
    echo "  $0 cleanup <namespace> [directory]     - Remove namespace logs"
    echo "  $0 restore [directory]                 - Restore from backups"
    echo "  $0 remove-backups [directory]          - Remove backup files"
    echo "  $0 list                                - Show available namespaces"
    echo ""
    echo "Examples:"
    echo "  $0 dry-run TEMP-DEBUG                  - Preview TEMP-DEBUG log removal"
    echo "  $0 cleanup TEMP-DEBUG src/             - Remove TEMP-DEBUG logs from src/"
    echo "  $0 dry-run API-DEBUG .                 - Preview API-DEBUG removal in current dir"
    echo ""
    show_namespaces
}

# Main script logic
case "$1" in
    "dry-run"|"--dry-run"|"-d")
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Please specify a namespace${NC}"
            show_namespaces
            exit 1
        fi
        dry_run_cleanup "$2" "$3"
        ;;
    "cleanup"|"--cleanup"|"-c")
        if [ -z "$2" ]; then
            echo -e "${RED}❌ Please specify a namespace${NC}"
            show_namespaces
            exit 1
        fi
        
        echo -e "${YELLOW}⚠️  This will remove all log statements with namespace [$2]${NC}"
        echo -e "${YELLOW}   Directory: ${3:-.}${NC}"
        echo ""
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cleanup_namespace_logs "$2" "$3"
        else
            echo -e "${BLUE}ℹ️  Operation cancelled${NC}"
        fi
        ;;
    "restore"|"--restore"|"-r")
        restore_backups "$2"
        ;;
    "remove-backups"|"--remove-backups"|"-rb")
        echo -e "${YELLOW}⚠️  This will permanently delete all backup files${NC}"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            remove_backups "$2"
        else
            echo -e "${BLUE}ℹ️  Operation cancelled${NC}"
        fi
        ;;
    "list"|"--list"|"-l")
        show_namespaces
        ;;
    *)
        show_usage
        ;;
esac
