# version v2
## find alias
fa() {
  if [[ -z "$1" ]]; then
    echo "Usage: fa <word>"
    return 1
  fi
  alias | grep -i "$1"
}

# find all alias and commnad in .aliases.zsh
faa() {
  if [[ -z "$1" ]]; then
    echo "Usage: fa <word>"
    return 1
  fi
  alias | grep -i "$1"
  cat ~/.aliases.zsh | grep -i -v "^alias" | grep -i "$1"
}
#Time and calendar
#
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias cal='cal -3'               # Lịch 3 tháng

# ================================
# 🐳 DOCKER & DEVOPS
# ================================
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dbash='docker exec -it'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dstop='docker stop $(docker ps -q)'
alias dlogs='docker logs -f'
alias dpg='docker ps | grep'
alias dnet='docker network ls'

# Custom for specify project
alias dlb='docker logs -f backend'
alias dlf='docker logs -f frontend'

# Docker Compose
alias dcps='docker compose ps'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
# frontend install package
alias dcfi='docker compose exec frontend npm install --verbose'
alias dcbi='docker compose exec api npm install --verbose'


# ================================
# 🗃️ DATABASE (MySQL, PostgreSQL, SQLite)
# ================================
# MySQL
alias mysql_login='mysql -u root -p'
alias mysqldump_all='mysqldump -u root -p --all-databases > alldb.sql'
alias mysql_import='mysql -u root -p < file.sql'

# PostgreSQL
alias pgstart='sudo service postgresql start'
alias pgstop='sudo service postgresql stop'
alias psql_login='psql -U postgres'

# SQLite
alias sqlite='sqlite3'

# ================================
# 🔁 WORKFLOWS / SHORTCUTS
# ================================
alias openfull='cd ~/Projects && code .'
# change directory
alias gop='cd ~/Projects'
alias gotpl='cd ~/Templates'
alias gos='cd ~/Projects/scripts'
alias gobk='cd ~/Backup'
alias gob='cd ~/Projects/backend'
alias gof='cd ~/Projects/frontend'
alias gofs='cd ~/Projects/fullstack'
alias goln='cd ~/Projects/learning'
alias godo='cd ~/Projects/devops'

# custom for certain project

# Clean & restart
alias cleanlogs='rm -rf logs/*'
alias rebuild='docker compose down && docker compose build && docker compose up -d'

# Python local server
alias serve='python3 -m http.server 8000'

# SSH
alias sshdev='ssh user@dev-server-ip'
alias sshprod='ssh user@prod-server-ip'

# Compress
alias zipdir='zip -r project.zip .'
alias unzipdir='unzip project.zip'

# Reload aliases
alias reload='source ~/.aliases.zsh && echo "✅ Aliases reloaded!"'
# ================================
# 🐍 PYTHON
# ================================
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias act='source .venv/bin/activate'
alias deact='deactivate'
alias pi='pip install'
alias pir='pip install -r requirements.txt'
alias pfreeze='pip freeze > requirements.txt'
alias pytest='python -m pytest'
# ================================
# 🌍 TERRAFORM
# ================================
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tfshow='terraform show'
alias f='find . -name'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias topmem='ps aux --sort=-%mem | head -n 10'  # Top 10 tiến trình dùng RAM
alias topcpu='ps aux --sort=-%cpu | head -n 10'  # Top 10 tiến trình dùng CPU
alias ip='ip a'
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias pingg='ping google.com'
alias speed='speedtest-cli'  # Cần cài đặt speedtest-cli
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

# Curl alias
# Ping API (GET request)
alias get='curl -X GET'

# Gửi POST request (form-urlencoded)
alias post='curl -X POST -H "Content-Type: application/x-www-form-urlencoded"'

# Gửi POST JSON
alias postjson='curl -X POST -H "Content-Type: application/json" -d'

# Kiểm tra HTTP headers
alias headers='curl -I'

# Theo dõi redirect
alias curlfollow='curl -L'

# Kiểm tra tốc độ tải (download)
alias curlspeed='curl -o /dev/null -s -w "%{speed_download}\n"'

# Kiểm tra response time
alias curltime='curl -o /dev/null -s -w "Total: %{time_total}s\n"'

# Gửi kèm token (Bearer)
alias curltoken='curl -H "Authorization: Bearer YOUR_TOKEN_HERE"'

# Kiểm tra API RESTful (thêm method & header tùy chỉnh)
alias apicall='curl -X GET -H "Content-Type: application/json"'

# Lưu file từ URL
alias curlsave='curl -O'  # Example: curlsave https://domain.com/file.zip

# Tải và hiển thị JSON đẹp (cần jq)
alias curljson='curl -s | jq'

# curlhealth
alias curlhealth='curl -s -o /dev/null -w "Status: %{http_code} | Time: %{time_total}s\n"'

# get IP of machine
alias myip="ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'"
alias mypublicip="curl -s https://api.ipify.org"

# curlupload
curlupload() {
  curl -X POST -F "file=@$1" "$2"
}

# curlenv
curlenv() {
  source .env
  curl -H "Authorization: Bearer $TOKEN" -H "Cookie: $COOKIE" "$@"
}

# migration for mkt_news
# Run all pending migrations
alias dcmr='docker compose exec api npm run migration:run'

# Revert the last migration
alias dcmrev='docker compose exec api npm run migration:revert'

# Generate a new migration from entity changes
dcmmg() {
  if [ -z "$1" ]; then
    echo "❌ Vui lòng nhập tên migration."
    return 1
  fi
  docker compose exec api npm run migration:generate --name="$1"
}

# Create an empty migration with a given name
dcmmc() {
  if [ -z "$1" ]; then
    echo "❌ Vui lòng nhập tên migration."
    return 1
  fi
  docker compose exec api npm run migration:create --name="$1"
}

redisdump() {
  # Lấy pattern từ tham số đầu tiên, nếu không có thì mặc định là '*'
  local pattern="${1:-*}"

  # Truyền pattern vào trong script của container
  # Lưu ý cách truyền biến $pattern vào script bên trong sh -c
  docker exec -i redis sh -c '
    pattern="$1"
    # Dùng --scan với --pattern để lọc key
    redis-cli --scan --pattern "$pattern" | while IFS= read -r key; do
      if [ -z "$key" ]; then
        continue
      fi
      type=$(redis-cli type "$key")
      case "$type" in
        string) value=$(redis-cli get "$key");;
        hash) value=$(redis-cli hgetall "$key" | sed "N;s/\\n/ -> /");;
        set) value=$(redis-cli smembers "$key");;
        list) value=$(redis-cli lrange "$key" 0 -1);;
        zset) value=$(redis-cli zrange "$key" 0 -1 withscores | sed "N;s/\\n/ (score: /;s/$/)/");;
        *) value="Không hỗ trợ lấy giá trị cho kiểu: $type";;
      esac
      echo "---"
      echo "> Key  : $key"
      echo "> Type : $type"
      echo "> Value:"
      echo "$value" | sed "s/^/    /"
    done
  ' sh "$pattern" # Đây là cách truyền biến $pattern vào script
}

# ================================
# 🐛 DEBUG LOG CLEANUP & MANAGEMENT
# ================================

# Debug log cleanup aliases - use scripts from MyConfig
alias debug-dry='~/MyConfig/scripts/cleanup-debug-logs.sh dry-run'
alias debug-clean='~/MyConfig/scripts/cleanup-debug-logs.sh cleanup'
alias debug-restore='~/MyConfig/scripts/cleanup-debug-logs.sh restore'
alias debug-list='~/MyConfig/scripts/cleanup-debug-logs.sh list'

# Python debug cleanup
alias py-debug-dry='~/MyConfig/scripts/cleanup-python-debug.sh dry-run'
alias py-debug-clean='~/MyConfig/scripts/cleanup-python-debug.sh cleanup'
alias py-debug-restore='~/MyConfig/scripts/cleanup-python-debug.sh restore'
alias py-debug-list='~/MyConfig/scripts/cleanup-python-debug.sh list'

# Quick namespace cleanup functions
clean-temp-logs() {
    echo "🧹 Cleaning TEMP-DEBUG logs..."
    echo "📄 JavaScript/TypeScript files:"
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec grep -l "\[TEMP-DEBUG\]" {} \; 2>/dev/null
    echo ""
    echo "📄 Python files:"
    find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec grep -l "\[TEMP-DEBUG\]" {} \; 2>/dev/null
    echo ""
    read -p "Proceed with cleanup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Cleanup JS/TS files
        find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec sed -i.backup '/\[TEMP-DEBUG\]/d' {} \; 2>/dev/null
        # Cleanup Python files
        find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec sed -i.backup '/\[TEMP-DEBUG\]/d' {} \; 2>/dev/null
        echo "✅ TEMP-DEBUG logs removed!"
        echo "💡 Backup files created with .backup extension"
    fi
}

# Clean all temporary debug logs (multiple namespaces)
clean-all-temp() {
    echo "🧹 Cleaning all temporary debug logs..."
    local temp_namespaces=("TEMP-DEBUG" "DEBUG-TEMP" "TMP-DEBUG")
    
    for ns in "${temp_namespaces[@]}"; do
        echo "🔍 Cleaning [$ns]..."
        find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/venv/*" ! -path "*/dist/*" -exec sed -i.backup "/\[${ns}\]/d" {} \; 2>/dev/null
    done
    
    echo "✅ All temporary debug logs removed!"
}

# Find all namespace logs
find-debug-logs() {
    local namespace=${1:-"DEBUG"}
    echo "🔍 Searching for all [$namespace] logs..."
    echo ""
    
    echo "📄 JavaScript/TypeScript files:"
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec grep -Hn "\[${namespace}\]" {} \; 2>/dev/null
    
    echo ""
    echo "📄 Python files:"
    find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec grep -Hn "\[${namespace}\]" {} \; 2>/dev/null
}

# Count debug logs by namespace
count-debug-logs() {
    echo "📊 Debug log statistics:"
    echo ""
    
    local namespaces=("API-DEBUG" "UI-DEBUG" "AUTH-DEBUG" "DB-DEBUG" "PERF-DEBUG" "TEMP-DEBUG")
    
    for ns in "${namespaces[@]}"; do
        local js_count=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec grep -c "\[${ns}\]" {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
        local py_count=$(find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec grep -c "\[${ns}\]" {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
        
        echo "[$ns]: JS/TS: $js_count, Python: $py_count"
    done
}

# Remove all backup files created by debug cleanup
remove-debug-backups() {
    echo "🗑️  Removing debug cleanup backup files..."
    
    local js_backups=$(find . -name "*.backup" -type f | wc -l)
    local py_backups=$(find . -name "*.py.backup" -type f | wc -l)
    
    if [ "$js_backups" -gt 0 ] || [ "$py_backups" -gt 0 ]; then
        echo "Found $js_backups JS/TS backup files and $py_backups Python backup files"
        read -p "Remove all backup files? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            find . -name "*.backup" -type f -delete
            find . -name "*.py.backup" -type f -delete
            echo "✅ All backup files removed!"
        else
            echo "ℹ️  Backup cleanup cancelled"
        fi
    else
        echo "✅ No backup files found!"
    fi
}

# Show debug cleanup help
# ================================
# 🐛 NAMESPACE DEBUGGING SYSTEM
# ================================

# ================================
# 🐛 NAMESPACE DEBUGGING SYSTEM - PERSONALIZED (NNC)
# ================================

# Personalized namespace constants
PREFIX_NAMESPACES=(
    "NNC-AUTH"     # Authentication & Authorization  
    "NNC-API"      # API calls and responses
    "NNC-DB"       # Database operations
    "NNC-UI"       # User Interface components
    "NNC-TEMP"     # Temporary debugging
    "NNC-PERF"     # Performance monitoring
    "NNC-CACHE"    # Caching operations
    "NNC-QUEUE"    # Queue operations
    "NNC-DEPLOY"   # Deployment processes
    "NNC-TEST"     # Testing & QA
)

# Display available NNC namespaces
nnc-namespaces() {
    echo "🏷️  Available NNC Namespaces:"
    for ns in "${PREFIX_NAMESPACES[@]}"; do
        echo "  📌 $ns"
    done
    echo ""
    echo "💡 Usage examples:"
    echo "  find-logs NNC-AUTH"
    echo "  remove-logs-dry NNC-TEMP"
    echo "  nnc-debug-auth"
}

# Quick NNC namespace-specific functions
alias nnc-debug-auth='find-logs NNC-AUTH'
alias nnc-debug-api='find-logs NNC-API'
alias nnc-debug-db='find-logs NNC-DB'
alias nnc-debug-ui='find-logs NNC-UI'
alias nnc-debug-temp='find-logs NNC-TEMP'
alias nnc-debug-perf='find-logs NNC-PERF'

# NNC cleanup shortcuts
alias nnc-clean-auth='remove-logs-dry NNC-AUTH && echo "Run: remove-logs NNC-AUTH"'
alias nnc-clean-api='remove-logs-dry NNC-API && echo "Run: remove-logs NNC-API"'
alias nnc-clean-db='remove-logs-dry NNC-DB && echo "Run: remove-logs NNC-DB"'
alias nnc-clean-temp='remove-logs-dry NNC-TEMP && echo "Run: remove-logs NNC-TEMP"'
alias nnc-clean-all='echo "⚠️  This will preview ALL NNC namespace cleanup" && for ns in "${PREFIX_NAMESPACES[@]}"; do echo "--- $ns ---"; remove-logs-dry $ns; done'

# NNC project-specific functions
nnc-project-debug() {
    local project_name=${1:-"current"}
    echo "🔍 NNC Debug Analysis for project: $project_name"
    echo "📊 Namespace Usage Statistics:"
    
    for ns in "${PREFIX_NAMESPACES[@]}"; do
        local count=$(count-logs "$ns" 2>/dev/null || echo "0")
        if [ "$count" != "0" ]; then
            echo "  $ns: $count logs"
        fi
    done
}

# NNC development workflow
nnc-dev-start() {
    echo "🚀 Starting NNC Development Session"
    echo "📋 Available namespaces: ${PREFIX_NAMESPACES[*]}"
    echo "💡 Use 'nnc-namespaces' to see all options"
    echo "🔧 Use 'nnc-project-debug' to analyze current project"
}

# Find logs by namespace
find-logs() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log *.txt"}
    if [ -z "$namespace" ]; then
        echo "Usage: find-logs <namespace> [file_pattern]"
        echo "Example: find-logs AUTH '*.js *.py'"
        return 1
    fi
    
    echo "🔍 Searching for [$namespace:*] logs in: $file_pattern"
    echo "📂 Directory: $(pwd)"
    echo ""
    
    local found=0
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f 2>/dev/null | while read file; do
            local matches=$(grep -n "\[$namespace:" "$file" 2>/dev/null)
            if [ ! -z "$matches" ]; then
                echo "📄 $file:"
                echo "$matches" | sed 's/^/  /'
                echo ""
                found=1
            fi
        done
    done
    
    if [ $found -eq 0 ]; then
        echo "❌ No logs found with namespace [$namespace:*]"
    fi
}

# Count logs by namespace
count-logs() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log *.txt"}
    if [ -z "$namespace" ]; then
        echo "Usage: count-logs <namespace> [file_pattern]"
        return 1
    fi
    
    local total=0
    for pattern in $file_pattern; do
        local count=$(find . -name "$pattern" -type f -exec grep -l "\[$namespace:" {} \; 2>/dev/null | wc -l)
        total=$((total + count))
    done
    
    echo "📊 Found $total files with [$namespace:*] logs"
    
    # Show breakdown by file type
    for pattern in $file_pattern; do
        local count=$(find . -name "$pattern" -type f -exec grep -c "\[$namespace:" {} \; 2>/dev/null | paste -sd+ | bc 2>/dev/null || echo 0)
        if [ $count -gt 0 ]; then
            echo "  📄 $pattern: $count log lines"
        fi
    done
}

# Remove logs by namespace (dry run)
remove-logs-dry() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log"}
    
    if [ -z "$namespace" ]; then
        echo "Usage: remove-logs-dry <namespace> [file_pattern]"
        echo "Example: remove-logs-dry AUTH '*.js *.py'"
        return 1
    fi
    
    echo "🔍 DRY RUN: Would remove logs matching [$namespace:*] from:"
    echo "📁 File pattern: $file_pattern"
    echo "📂 Current directory: $(pwd)"
    echo ""
    
    local files_affected=0
    local lines_affected=0
    
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f 2>/dev/null | while read file; do
            local matches=$(grep -n "\[$namespace:" "$file" 2>/dev/null)
            if [ ! -z "$matches" ]; then
                files_affected=$((files_affected + 1))
                local line_count=$(echo "$matches" | wc -l)
                lines_affected=$((lines_affected + line_count))
                
                echo "📄 File: $file ($line_count lines to remove)"
                echo "$matches" | head -3 | sed 's/^/  📍 /'
                if [ $line_count -gt 3 ]; then
                    echo "    ... and $((line_count - 3)) more lines"
                fi
                echo ""
            fi
        done
    done
    
    echo "� Summary:"
    echo "  🗂️  Files affected: $files_affected"
    echo "  📄 Lines to remove: $lines_affected"
    echo ""
    echo "💡 To proceed: remove-logs $namespace"
}

# Remove logs by namespace (actual removal)
remove-logs() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log"}
    
    if [ -z "$namespace" ]; then
        echo "Usage: remove-logs <namespace> [file_pattern]"
        echo "Note: Run remove-logs-dry first to preview changes"
        echo "Example: remove-logs AUTH '*.js *.py'"
        return 1
    fi
    
    echo "⚠️  WARNING: This will remove all logs matching [$namespace:*]"
    echo "📁 File pattern: $file_pattern"
    echo "📂 Directory: $(pwd)"
    echo ""
    read -p "Continue? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        local files_processed=0
        local backup_dir="./debug_backups_$(date +%Y%m%d_%H%M%S)"
        
        echo "📁 Creating backup directory: $backup_dir"
        mkdir -p "$backup_dir"
        
        for pattern in $file_pattern; do
            find . -name "$pattern" -type f 2>/dev/null | while read file; do
                if grep -q "\[$namespace:" "$file" 2>/dev/null; then
                    files_processed=$((files_processed + 1))
                    echo "🧹 Processing: $file"
                    
                    # Create backup
                    local backup_file="$backup_dir/$(echo "$file" | sed 's/\.\///g' | tr '/' '_')"
                    cp "$file" "$backup_file"
                    
                    # Remove lines with namespace
                    grep -v "\[$namespace:" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                fi
            done
        done
        
        echo ""
        echo "✅ Log cleanup completed!"
        echo "📁 Backups saved in: $backup_dir"
        echo "🔄 To restore: restore-debug-logs $backup_dir"
    else
        echo "❌ Operation cancelled"
    fi
}

# Restore from backup
restore-debug-logs() {
    local backup_dir=$1
    if [ -z "$backup_dir" ] || [ ! -d "$backup_dir" ]; then
        echo "Usage: restore-debug-logs <backup_directory>"
        echo "Available backups:"
        ls -la ./debug_backups_* 2>/dev/null || echo "  No backups found"
        return 1
    fi
    
    echo "🔄 Restoring files from: $backup_dir"
    echo "⚠️  This will overwrite current files!"
    read -p "Continue? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        for backup_file in "$backup_dir"/*; do
            if [ -f "$backup_file" ]; then
                local original_file="./$(basename "$backup_file" | tr '_' '/')"
                local original_dir=$(dirname "$original_file")
                
                mkdir -p "$original_dir"
                cp "$backup_file" "$original_file"
                echo "✅ Restored: $original_file"
            fi
        done
        echo "🎉 Restore completed!"
    else
        echo "❌ Restore cancelled"
    fi
}

# List all namespaces in current directory
list-namespaces() {
    local file_pattern=${1:-"*.js *.ts *.py *.log *.txt"}
    echo "🔍 Finding all namespaces in: $file_pattern"
    echo "📂 Directory: $(pwd)"
    echo ""
    
    local temp_file=$(mktemp)
    
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f -exec grep -h "\[.*:" {} \; 2>/dev/null | \
        sed -n 's/.*\[\([^:]*\):.*/\1/p' >> "$temp_file"
    done
    
    if [ -s "$temp_file" ]; then
        echo "📊 Namespaces found:"
        sort "$temp_file" | uniq -c | sort -nr | while read count namespace; do
            if [ ! -z "$namespace" ]; then
                echo "  📌 $namespace: $count occurrences"
            fi
        done
    else
        echo "❌ No namespace logs found"
    fi
    
    rm "$temp_file"
}

# Clean all debug logs (dry run)
clean-debug-dry() {
    local file_pattern=${1:-"*.js *.ts *.py *.log"}
    echo "🔍 DRY RUN: Would remove all debug logs with pattern: $file_pattern"
    echo ""
    
    local total_files=0
    local total_lines=0
    
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f 2>/dev/null | while read file; do
            local debug_lines=$(grep -c "\[.*:" "$file" 2>/dev/null || echo 0)
            if [ $debug_lines -gt 0 ]; then
                total_files=$((total_files + 1))
                total_lines=$((total_lines + debug_lines))
                echo "📄 $file: $debug_lines debug lines"
            fi
        done
    done
    
    echo ""
    echo "📊 Total: $total_files files, $total_lines debug lines"
    echo "💡 To clean all: clean-debug-all"
}

# Clean all debug logs
clean-debug-all() {
    local file_pattern=${1:-"*.js *.ts *.py *.log"}
    echo "🧹 Removing all debug logs with pattern: $file_pattern"
    echo "⚠️  This will remove ALL namespace logs!"
    read -p "Continue? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        local backup_dir="./all_debug_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        
        for pattern in $file_pattern; do
            find . -name "$pattern" -type f 2>/dev/null | while read file; do
                if grep -q "\[.*:" "$file" 2>/dev/null; then
                    echo "🧹 Cleaning: $file"
                    local backup_file="$backup_dir/$(echo "$file" | sed 's/\.\///g' | tr '/' '_')"
                    cp "$file" "$backup_file"
                    grep -v "\[.*:" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                fi
            done
        done
        
        echo "✅ All debug logs cleaned!"
        echo "📁 Backup: $backup_dir"
    else
        echo "❌ Operation cancelled"
    fi
}

# Quick namespace-specific functions
alias debug-auth='find-logs AUTH'
alias debug-api='find-logs API'
alias debug-db='find-logs DB'
alias debug-ui='find-logs UI'
alias debug-temp='find-logs TEMP'

# Cleanup shortcuts
alias clean-auth='remove-logs-dry AUTH && echo "Run: remove-logs AUTH"'
alias clean-api='remove-logs-dry API && echo "Run: remove-logs API"'
alias clean-db='remove-logs-dry DB && echo "Run: remove-logs DB"'
alias clean-temp='remove-logs-dry TEMP && echo "Run: remove-logs TEMP"'

debug-help() {
    echo "🐛 Namespace Debug Log Management System"
    echo ""
    echo "📋 Core Commands:"
    echo "  find-logs <namespace> [pattern]     - Find logs with namespace"
    echo "  count-logs <namespace> [pattern]    - Count logs with namespace"
    echo "  remove-logs-dry <namespace>         - Preview log removal"
    echo "  remove-logs <namespace>             - Remove logs (with backup)"
    echo "  list-namespaces [pattern]           - Show all available namespaces"
    echo ""
    echo "� Backup & Restore:"
    echo "  restore-debug-logs <backup_dir>     - Restore from backup"
    echo "  clean-debug-dry [pattern]           - Preview removal of ALL debug logs"
    echo "  clean-debug-all [pattern]           - Remove ALL debug logs"
    echo ""
    echo "⚡ Quick Shortcuts:"
    echo "  debug-auth, debug-api, debug-db     - Find specific namespace logs"
    echo "  clean-auth, clean-api, clean-db     - Quick cleanup preview"
    echo ""
    echo "📝 Namespace Convention:"
    echo "  [NAMESPACE:LEVEL] Message"
    echo "  Examples: [AUTH:ERROR], [API:DEBUG], [DB:INFO]"
    echo ""
    echo "💡 Example Workflow:"
    echo "  1. list-namespaces                  - See what's available"
    echo "  2. find-logs TEMP                   - Check temp logs"
    echo "  3. remove-logs-dry TEMP             - Preview removal"
    echo "  4. remove-logs TEMP                 - Clean up"
    echo ""
    echo "📖 Full documentation: docs/NamespaceDebugging.md"
}

# NNC Help - Personalized debugging help
nnc-help() {
    echo "🏷️  NNC Personalized Debugging System"
    echo ""
    echo "🎯 Your Personal Namespaces:"
    echo "  NNC-AUTH    - Authentication & Authorization"
    echo "  NNC-API     - API calls and responses"
    echo "  NNC-DB      - Database operations" 
    echo "  NNC-UI      - User Interface components"
    echo "  NNC-TEMP    - Temporary debugging"
    echo "  NNC-PERF    - Performance monitoring"
    echo "  NNC-CACHE   - Caching operations"
    echo "  NNC-QUEUE   - Queue operations"
    echo "  NNC-DEPLOY  - Deployment processes"
    echo "  NNC-TEST    - Testing & QA"
    echo ""
    echo "⚡ Quick NNC Commands:"
    echo "  nnc-namespaces                      - Show all NNC namespaces"
    echo "  nnc-debug-auth                      - Find NNC-AUTH logs"
    echo "  nnc-debug-api                       - Find NNC-API logs"
    echo "  nnc-debug-temp                      - Find NNC-TEMP logs"
    echo "  nnc-clean-auth                      - Preview NNC-AUTH cleanup"
    echo "  nnc-clean-all                       - Preview all NNC cleanup"
    echo "  nnc-project-debug                   - Analyze current project"
    echo "  nnc-dev-start                       - Start NNC session"
    echo ""
    echo "💡 Usage Examples:"
    echo "  # In your code:"
    echo "  console.log('[NNC-AUTH:DEBUG] User login attempt', user);"
    echo "  print('[NNC-DB:INFO] Query executed successfully')"
    echo ""
    echo "  # Find and clean:"
    echo "  nnc-debug-auth                      # Find auth logs"
    echo "  nnc-clean-auth                      # Preview cleanup"
    echo "  remove-logs NNC-AUTH                # Actually clean"
    echo ""
    echo "🔗 For generic commands: debug-help"
}