#!/bin/bash

# ================================
# 🚀 AUTO CI/CD SCRIPT v1.0
# ================================
# This script automates the CI/CD workflow with the following steps:
# Usage: auto_cicd "commit message" [-a|-u] [--no-push] [--no-slack]
#   -a: git add -A (all files, default)
#   -u: git add -u (only tracked files)
#   --no-push: skip git push
#   --no-slack: skip slack notification
#
# Steps:
# 1. git diff - show changes
# 2. git add -A or git add -u
# 3. git commit -m with message
# 4. run pre-commit and fix issues until success
# 5. git log to see last commit
# 6. git diff stat to see changes
# 7. git push origin current-branch
# 8. create report message with last commit hash and diff stat
# 9. copy to clipboard
# 10. if slack webhook url is set, send message to slack channel
# ================================

# Configuration
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"  # Set in environment or .env file
MAX_PRECOMMIT_RETRIES=3

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🔹 $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

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
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        print_error "Not a git repository!"
        return 1
    fi
    return 0
}

# Copy to clipboard (cross-platform)
copy_to_clipboard() {
    local text="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -n "$text" | pbcopy
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v xclip &>/dev/null; then
            echo -n "$text" | xclip -selection clipboard
        elif command -v xsel &>/dev/null; then
            echo -n "$text" | xsel --clipboard --input
        else
            print_warning "No clipboard tool found (xclip/xsel). Install one for clipboard support."
            return 1
        fi
    elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
        echo -n "$text" | clip
    else
        print_warning "Unsupported OS for clipboard"
        return 1
    fi
    return 0
}

# Send Slack notification
send_slack_notification() {
    local message="$1"
    
    if [[ -z "$SLACK_WEBHOOK_URL" ]]; then
        print_info "Slack webhook URL not configured. Skipping notification."
        return 0
    fi
    
    local payload=$(cat <<EOF
{
    "text": "$message",
    "mrkdwn": true
}
EOF
)
    
    local response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "$SLACK_WEBHOOK_URL")
    
    if [[ "$response" == "200" ]]; then
        print_success "Slack notification sent!"
        return 0
    else
        print_warning "Failed to send Slack notification (HTTP $response)"
        return 1
    fi
}

# Run pre-commit with retry logic
run_precommit() {
    local retry_count=0
    
    if ! command -v pre-commit &>/dev/null; then
        print_warning "pre-commit not installed. Skipping pre-commit checks."
        return 0
    fi
    
    while [[ $retry_count -lt $MAX_PRECOMMIT_RETRIES ]]; do
        print_info "Running pre-commit (attempt $((retry_count + 1))/$MAX_PRECOMMIT_RETRIES)..."
        
        if pre-commit run --all-files; then
            print_success "Pre-commit passed!"
            return 0
        else
            retry_count=$((retry_count + 1))
            
            if [[ $retry_count -lt $MAX_PRECOMMIT_RETRIES ]]; then
                print_warning "Pre-commit failed. Auto-fixing and retrying..."
                # Stage any auto-fixed files
                git add -A
            fi
        fi
    done
    
    print_error "Pre-commit failed after $MAX_PRECOMMIT_RETRIES attempts."
    echo -e "${YELLOW}Do you want to continue anyway? (y/N):${NC} "
    read -r continue_choice
    if [[ "$continue_choice" =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

# Main function
auto_cicd() {
    local commit_message="$1"
    local add_mode="-A"  # Default: add all files
    local do_push=true
    local do_slack=true
    
    # Parse arguments
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -u)
                add_mode="-u"
                ;;
            -a)
                add_mode="-A"
                ;;
            --no-push)
                do_push=false
                ;;
            --no-slack)
                do_slack=false
                ;;
            *)
                print_warning "Unknown option: $1"
                ;;
        esac
        shift
    done
    
    # Validate commit message
    if [[ -z "$commit_message" ]]; then
        print_error "Usage: auto_cicd \"commit message\" [-a|-u] [--no-push] [--no-slack]"
        echo "  -a: git add -A (all files, default)"
        echo "  -u: git add -u (only tracked files)"
        echo "  --no-push: skip git push"
        echo "  --no-slack: skip slack notification"
        return 1
    fi
    
    # Check git repo
    check_git_repo || return 1
    
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local repo_name=$(basename "$(git rev-parse --show-toplevel)")
    
    echo -e "\n${GREEN}🚀 AUTO CI/CD WORKFLOW STARTED${NC}"
    echo -e "${CYAN}📂 Repository: ${repo_name}${NC}"
    echo -e "${CYAN}🌿 Branch: ${current_branch}${NC}"
    echo -e "${CYAN}📝 Message: ${commit_message}${NC}"
    
    # Step 1: Show git diff
    print_step "Step 1: Showing changes (git diff)"
    if git diff --stat | head -20; then
        local changes_count=$(git diff --stat | tail -1)
        if [[ -n "$changes_count" ]]; then
            echo -e "${YELLOW}$changes_count${NC}"
        fi
    fi
    
    # Check if there are changes to commit
    if [[ -z "$(git status --porcelain)" ]]; then
        print_warning "No changes to commit."
        return 0
    fi
    
    # Confirm before proceeding
    echo -e "\n${YELLOW}Do you want to proceed with the commit? (Y/n):${NC} "
    read -r proceed_choice
    if [[ "$proceed_choice" =~ ^[Nn]$ ]]; then
        print_info "Aborted by user."
        return 0
    fi
    
    # Step 2: Git add
    print_step "Step 2: Staging changes (git add $add_mode)"
    git add $add_mode
    git status --short
    print_success "Changes staged!"
    
    # Step 3: Run pre-commit
    print_step "Step 3: Running pre-commit hooks"
    if ! run_precommit; then
        print_error "Pre-commit failed. Aborting."
        return 1
    fi
    
    # Step 4: Git commit
    print_step "Step 4: Committing changes"
    if git commit -m "$commit_message"; then
        print_success "Changes committed!"
    else
        print_error "Commit failed!"
        return 1
    fi
    
    # Step 5: Show git log
    print_step "Step 5: Last commit details"
    git log -1 --pretty=format:"${GREEN}Hash:${NC} %h%n${GREEN}Author:${NC} %an <%ae>%n${GREEN}Date:${NC} %ad%n${GREEN}Message:${NC} %s" --date=short
    echo ""
    
    # Step 6: Show diff stat
    print_step "Step 6: Changes summary (diff stat)"
    local diff_stat=$(git diff --stat HEAD~1 2>/dev/null || git diff --stat HEAD)
    echo "$diff_stat"
    
    # Get commit info for report
    local commit_hash=$(git rev-parse --short HEAD)
    local commit_full_hash=$(git rev-parse HEAD)
    local commit_author=$(git log -1 --pretty=format:"%an")
    local commit_date=$(git log -1 --pretty=format:"%ad" --date=short)
    local files_changed=$(git diff --stat HEAD~1 2>/dev/null | tail -1 || echo "N/A")
    
    # Step 7: Git push
    if [[ "$do_push" == true ]]; then
        print_step "Step 7: Pushing to origin/$current_branch"
        if git push origin "$current_branch"; then
            print_success "Pushed to origin/$current_branch!"
        else
            print_error "Push failed!"
            echo -e "${YELLOW}Do you want to force push? (y/N):${NC} "
            read -r force_choice
            if [[ "$force_choice" =~ ^[Yy]$ ]]; then
                if git push origin "$current_branch" --force-with-lease; then
                    print_success "Force pushed to origin/$current_branch!"
                else
                    print_error "Force push failed!"
                    return 1
                fi
            else
                return 1
            fi
        fi
    else
        print_step "Step 7: Skipping push (--no-push)"
    fi
    
    # Step 8: Create report message
    print_step "Step 8: Generating report"
    
    local report=$(cat <<EOF
🚀 *Deployment Report*
━━━━━━━━━━━━━━━━━━━━━━━━━
📂 *Repository:* ${repo_name}
🌿 *Branch:* ${current_branch}
👤 *Author:* ${commit_author}
📅 *Date:* ${commit_date}

📝 *Commit:* \`${commit_hash}\`
💬 *Message:* ${commit_message}

📊 *Changes:*
${files_changed}

🔗 *Full Hash:* ${commit_full_hash}
━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
)
    
    echo "$report"
    
    # Step 9: Copy to clipboard
    print_step "Step 9: Copying to clipboard"
    if copy_to_clipboard "$report"; then
        print_success "Report copied to clipboard!"
    fi
    
    # Step 10: Send Slack notification
    if [[ "$do_slack" == true ]]; then
        print_step "Step 10: Sending Slack notification"
        # Escape special characters for Slack JSON
        local slack_message=$(echo "$report" | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/  / /g')
        send_slack_notification "$slack_message"
    else
        print_step "Step 10: Skipping Slack notification (--no-slack)"
    fi
    
    # Done
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 AUTO CI/CD WORKFLOW COMPLETED SUCCESSFULLY!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    return 0
}

# Quick commit without pre-commit (for emergencies)
quick_commit() {
    local commit_message="$1"
    
    if [[ -z "$commit_message" ]]; then
        print_error "Usage: quick_commit \"commit message\""
        return 1
    fi
    
    check_git_repo || return 1
    
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    git add -A
    git commit -m "$commit_message" --no-verify
    git push origin "$current_branch"
    
    print_success "Quick commit done! (pre-commit skipped)"
}

# Export functions for use in shell
export -f auto_cicd
export -f quick_commit

# If script is run directly (not sourced), execute auto_cicd with arguments
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    auto_cicd "$@"
fi
