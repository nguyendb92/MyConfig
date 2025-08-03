# ⚡ Quick Reference - MyConfig

> **Tham khảo nhanh các commands, shortcuts và workflows thường dùng**

## 📋 Mục lục
- [Setup Commands](#-setup-commands)
- [Development Workflow](#-development-workflow)
- [Vim Shortcuts](#-vim-shortcuts)
- [VS Code Shortcuts](#-vs-code-shortcuts)
- [Docker Commands](#-docker-commands)
- [Database Commands](#-database-commands)
- [Git Aliases](#-git-aliases)
- [System Monitoring](#-system-monitoring)
- [WSL Specific Commands](#-wsl-specific-commands)

---

## 🚀 Setup Commands

### Initial Setup
```bash
# Clone and setup
git clone https://github.com/nguyendb92/MyConfig.git
cd MyConfig
chmod +x auto_setup.sh
./auto_setup.sh

# WSL advanced setup
make wsl-setup

# Install VS Code extensions
make install-ext

# Post-setup configuration
make post-setup
```

### Quick Environment Check
```bash
make check          # Check environment status
make info           # Show system information
make wsl-check      # Check WSL environment (if applicable)
make help           # Show all available commands
```
```bash
# Start all services
make dev-start
start-all-dev-services  # WSL alias

# Check services status
make dev-status

# Stop services
make dev-stop
stop-all-dev-services  # WSL alias

# Individual services (WSL)
start-mysql
start-postgres
start-redis
```

### Project Creation
```bash
# React project
make create-react PROJECT_NAME

# Vue project  
make create-vue PROJECT_NAME

# Node.js project
make create-node PROJECT_NAME

# Python project
make create-python PROJECT_NAME
```

### Environment Check
```bash
# Full environment check
make check

# WSL specific check
make wsl-check

# Quick validation
./validate_simple.sh

# WSL info
wsl-info
```

## 🪟 WSL Specific

### Service Management
```bash
# Check if WSL
make wsl-check

# WSL advanced setup
make wsl-setup

# Restart WSL services
sudo service mysql start
sudo service postgresql start
sudo service redis-server start
```

### Windows Integration
```bash
# Open Windows Explorer
open-explorer

# Open VS Code on Windows
code-windows .

# Path conversion
to-windows-path /mnt/c/Users
to-wsl-path C:\Users
```

## 🐳 Docker Commands

### Basic Docker
```bash
# Check Docker status
docker ps

# Docker compose
docker compose up -d
docker compose down

# Quick containers
dps     # docker ps
dcu     # docker compose up
dcd     # docker compose down
```

## 🗃️ Database Quick Access

### MySQL
```bash
# Start MySQL (WSL)
sudo service mysql start

# Connect to MySQL
mysql -u root -p

# Quick login alias
mysql_login
```

### PostgreSQL
```bash
# Start PostgreSQL (WSL)
sudo service postgresql start

# Connect as postgres user
sudo -u postgres psql

# Aliases
pgstart
pgstop
```

### Redis
```bash
# Start Redis (WSL)
sudo service redis-server start

# Connect to Redis
redis-cli

# Check Redis status
redis-cli ping
```

## 📁 Directory Structure

```
~/Projects/
├── frontend/          # React, Vue, Angular
├── backend/           # Node.js, Python, etc.
├── fullstack/         # Full-stack apps
├── mobile/            # React Native, Flutter
├── devops/            # Docker, K8s configs
└── learning/          # Learning projects

~/Templates/           # Project templates
~/Scripts/             # Custom scripts
~/Backups/             # Config backups
```

## 🔧 Configuration Files

### Important Config Locations
```bash
~/.vimrc               # Vim configuration
~/.zshrc               # Zsh configuration  
~/.aliases.zsh         # Custom aliases
~/.wsl_dev_aliases.zsh # WSL specific aliases
~/.config/Code/User/   # VS Code settings
```

### Quick Edit Configs
```bash
# Edit Vim config
vim ~/.vimrc

# Edit Zsh config
vim ~/.zshrc

# Edit aliases
vim ~/.aliases.zsh

# Reload Zsh config
source ~/.zshrc
```

## 🚨 Troubleshooting

### Common Issues
```bash
# Docker permission denied
sudo usermod -aG docker $USER
# Then logout/login

# WSL services not starting
sudo service --status-all

# VS Code not opening
code --install-extension ms-vscode-remote.remote-wsl

# Node/npm issues
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs
```

### Reset & Reinstall
```bash
# Full reset (careful!)
./auto_setup.sh

# Just install extensions
./install_extensions.sh

# Validate setup
./validate_setup.sh
```

## 💡 Pro Tips

### Productivity Hacks
1. **Use aliases**: `proj` to go to Projects folder
2. **Quick navigation**: `ranger` for file browsing
3. **Fast search**: `rg "pattern"` (ripgrep)
4. **Better ls**: `exa` or `ls -la` with colors

### Git Workflow
```bash
# Quick git commands
gst     # git status
ga      # git add
gc      # git commit
gp      # git push
gl      # git pull
gco     # git checkout
```

### VS Code Integration
```bash
# Open current directory in VS Code
code .

# Open specific file
code filename

# Compare files
code --diff file1 file2
```

---

*🔖 Bookmark this page for quick reference during development!*
