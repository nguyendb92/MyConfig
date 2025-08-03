# ================================
# 🔧 MYCONFIG ALIASES v3.0
# ================================
# Find alias
fa() {
    if [[ -z "$1" ]]; then
        echo "Usage: fa <word>"
        return 1
    fi
    alias | grep -i "$1"
}

# Find all alias and command in .aliases.zsh
faa() {
    if [[ -z "$1" ]]; then
        echo "Usage: faa <word>"
        return 1
    fi
    alias | grep -i "$1"
    cat ~/.aliases.zsh | grep -i -v "^alias" | grep -i "$1"
}

# ================================
# 🕐 TIME AND CALENDAR
# ================================
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias cal='cal -3'

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

# Docker Compose - Package installation
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

# ================================
# 🔍 SYSTEM & SEARCH UTILITIES
# ================================
alias f='find . -name'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias topmem='ps aux --sort=-%mem | head -n 10'  # Top 10 tiến trình dùng RAM
alias topcpu='ps aux --sort=-%cpu | head -n 10'  # Top 10 tiến trình dùng CPU

# ================================
# 🌐 NETWORK & PACKAGE MANAGEMENT
# ================================
alias ip='ip a'
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias pingg='ping google.com'
alias speed='speedtest-cli'  # Cần cài đặt speedtest-cli
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

# ================================
# 🌐 CURL & API UTILITIES
# ================================
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

# ================================
# 🗂️ DATABASE MIGRATIONS
# ================================
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

# ================================
# 🔴 REDIS UTILITIES
# ================================

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


# Namespace constants
PREFIX_NAMESPACES=(
    "AUTH"     # Authentication & Authorization  
    "API"      # API calls and responses
    "DB"       # Database operations
    "UI"       # User Interface components
    "TEMP"     # Temporary debugging
    "PERF"     # Performance monitoring
    "CACHE"    # Caching operations
    "QUEUE"    # Queue operations
    "DEPLOY"   # Deployment processes
    "TEST"     # Testing & QA
)

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
