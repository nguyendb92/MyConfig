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