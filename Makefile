# =============================================================================
# Makefile for MyConfig - Fullstack Developer Environment Setup
# =============================================================================

.PHONY: help install setup-vim setup-vscode install-extensions post-setup check clean

# Default target
help:
	@echo "MyConfig - Fullstack Developer Environment Setup"
	@echo ""
	@echo "Available commands:"
	@echo "  make install          - Full automated installation (recommended)"
	@echo "  make wsl-setup        - WSL-specific advanced setup"
	@echo "  make setup-vim        - Setup Vim configuration only"
	@echo "  make setup-vscode     - Setup VS Code configuration only"
	@echo "  make install-ext      - Install VS Code extensions only"
	@echo "  make post-setup       - Run post-installation configuration"
	@echo "  make check            - Check environment and troubleshoot"
	@echo "  make update           - Update all tools and packages"
	@echo "  make backup           - Backup current configurations"
	@echo "  make restore          - Restore configurations from backup"
	@echo "  make clean            - Clean up temporary files"
	@echo "  make info             - Show system information"
	@echo "  make dev-start        - Start development services"
	@echo "  make dev-stop         - Stop development services"
	@echo "  make validate         - Quick environment validation"
	@echo ""
	@echo "WSL-specific commands:"
	@echo "  make wsl-check        - Check if running in WSL"
	@echo "  make wsl-services     - Manage WSL services"
	@echo "  make wsl-restart      - Restart WSL (requires Windows)"
	@echo ""
	@echo "Quick start for new machine:"
	@echo "  Ubuntu: make install && make post-setup"
	@echo "  WSL:    make install && make wsl-setup"

# Full installation
install:
	@echo "🚀 Starting full environment setup..."
	@chmod +x auto_setup.sh
	@./auto_setup.sh

# Vim setup only
setup-vim:
	@echo "⚡ Setting up Vim configuration..."
	@chmod +x setup_vim.sh
	@./setup_vim.sh
	@echo "✅ Vim setup completed. Run 'vim' and ':PlugInstall' to install plugins."

# VS Code setup only
setup-vscode:
	@echo "🎨 Setting up VS Code configuration..."
	@mkdir -p ~/.config/Code/User
	@if [ -f "vscode/settings.json" ]; then \
		cp vscode/settings.json ~/.config/Code/User/; \
		echo "✅ VS Code settings copied"; \
	else \
		echo "❌ VS Code settings.json not found"; \
	fi
	@if [ -f "vscode/keybindings.json" ]; then \
		cp vscode/keybindings.json ~/.config/Code/User/; \
		echo "✅ VS Code keybindings copied"; \
	else \
		echo "❌ VS Code keybindings.json not found"; \
	fi

# Install VS Code extensions
install-ext:
	@echo "🔌 Installing VS Code extensions..."
	@chmod +x install_extensions.sh
	@./install_extensions.sh

# Post-installation setup
post-setup:
	@echo "⚙️  Running post-installation configuration..."
	@chmod +x post_setup.sh
	@./post_setup.sh

# Check environment
check:
	@echo "🔍 Checking development environment..."
	@chmod +x check_environment.sh
	@./check_environment.sh

# Update system and tools
update:
	@echo "🔄 Updating system and development tools..."
	@sudo apt update && sudo apt upgrade -y
	@if command -v npm >/dev/null 2>&1; then \
		echo "Updating npm packages..."; \
		npm update -g; \
	fi
	@if command -v pip3 >/dev/null 2>&1; then \
		echo "Updating pip packages..."; \
		pip3 install --upgrade --user pip setuptools wheel; \
	fi
	@if command -v code >/dev/null 2>&1; then \
		echo "Updating VS Code extensions..."; \
		code --update-extensions; \
	fi
	@echo "✅ Update completed"

# Backup configurations
backup:
	@echo "💾 Creating backup of current configurations..."
	@mkdir -p backups/$(shell date +%Y%m%d_%H%M%S)
	@BACKUP_DIR=backups/$(shell date +%Y%m%d_%H%M%S); \
	if [ -f ~/.vimrc ]; then cp ~/.vimrc $$BACKUP_DIR/; fi; \
	if [ -f ~/.zshrc ]; then cp ~/.zshrc $$BACKUP_DIR/; fi; \
	if [ -f ~/.aliases.zsh ]; then cp ~/.aliases.zsh $$BACKUP_DIR/; fi; \
	if [ -f ~/.config/Code/User/settings.json ]; then \
		mkdir -p $$BACKUP_DIR/vscode; \
		cp ~/.config/Code/User/settings.json $$BACKUP_DIR/vscode/; \
	fi; \
	if [ -f ~/.config/Code/User/keybindings.json ]; then \
		mkdir -p $$BACKUP_DIR/vscode; \
		cp ~/.config/Code/User/keybindings.json $$BACKUP_DIR/vscode/; \
	fi; \
	echo "✅ Backup created in $$BACKUP_DIR"

# Restore from latest backup
restore:
	@echo "🔄 Restoring configurations from latest backup..."
	@LATEST_BACKUP=$$(ls -1t backups/ | head -1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "❌ No backup found"; \
		exit 1; \
	fi; \
	echo "Restoring from $$LATEST_BACKUP..."; \
	if [ -f "backups/$$LATEST_BACKUP/vimrc" ]; then \
		cp "backups/$$LATEST_BACKUP/vimrc" ~/.vimrc; \
	fi; \
	if [ -f "backups/$$LATEST_BACKUP/zshrc" ]; then \
		cp "backups/$$LATEST_BACKUP/zshrc" ~/.zshrc; \
	fi; \
	if [ -f "backups/$$LATEST_BACKUP/aliases.zsh" ]; then \
		cp "backups/$$LATEST_BACKUP/aliases.zsh" ~/.aliases.zsh; \
	fi; \
	if [ -f "backups/$$LATEST_BACKUP/vscode/settings.json" ]; then \
		mkdir -p ~/.config/Code/User; \
		cp "backups/$$LATEST_BACKUP/vscode/settings.json" ~/.config/Code/User/; \
	fi; \
	if [ -f "backups/$$LATEST_BACKUP/vscode/keybindings.json" ]; then \
		mkdir -p ~/.config/Code/User; \
		cp "backups/$$LATEST_BACKUP/vscode/keybindings.json" ~/.config/Code/User/; \
	fi; \
	echo "✅ Restore completed from $$LATEST_BACKUP"

# Clean up
clean:
	@echo "🧹 Cleaning up temporary files..."
	@rm -f *.log
	@rm -f /tmp/myconfig_*
	@sudo apt autoremove -y
	@sudo apt autoclean
	@if command -v docker >/dev/null 2>&1; then \
		docker system prune -f; \
	fi
	@echo "✅ Cleanup completed"

# Show system information
info:
	@echo "📊 System Information:"
	@echo "OS: $$(lsb_release -d | cut -f2 2>/dev/null || echo 'Unknown')"
	@echo "Kernel: $$(uname -r)"
	@echo "Architecture: $$(uname -m)"
	@echo "Shell: $$SHELL"
	@echo "User: $$USER"
	@echo ""
	@echo "📦 Development Tools:"
	@echo "Node.js: $$(node --version 2>/dev/null || echo 'Not installed')"
	@echo "Python: $$(python3 --version 2>/dev/null || echo 'Not installed')"
	@echo "Git: $$(git --version 2>/dev/null || echo 'Not installed')"
	@echo "Docker: $$(docker --version 2>/dev/null || echo 'Not installed')"
	@echo "VS Code: $$(code --version 2>/dev/null | head -1 || echo 'Not installed')"

# Development shortcuts
dev-start:
	@echo "🚀 Starting development services..."
	@if systemctl list-unit-files | grep -q mysql; then \
		sudo systemctl start mysql; \
		echo "✅ MySQL started"; \
	fi
	@if systemctl list-unit-files | grep -q postgresql; then \
		sudo systemctl start postgresql; \
		echo "✅ PostgreSQL started"; \
	fi
	@if systemctl list-unit-files | grep -q redis-server; then \
		sudo systemctl start redis-server; \
		echo "✅ Redis started"; \
	fi
	@if systemctl list-unit-files | grep -q docker; then \
		sudo systemctl start docker; \
		echo "✅ Docker started"; \
	fi

dev-stop:
	@echo "🛑 Stopping development services..."
	@if systemctl list-unit-files | grep -q mysql; then \
		sudo systemctl stop mysql; \
		echo "✅ MySQL stopped"; \
	fi
	@if systemctl list-unit-files | grep -q postgresql; then \
		sudo systemctl stop postgresql; \
		echo "✅ PostgreSQL stopped"; \
	fi
	@if systemctl list-unit-files | grep -q redis-server; then \
		sudo systemctl stop redis-server; \
		echo "✅ Redis stopped"; \
	fi

# Quick project creation
# Create new project shortcuts
create-react:
	@read -p "Enter project name: " name; \
	if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🚀 Creating React project in WSL environment..."; \
		mkdir -p ~/Projects/frontend && cd ~/Projects/frontend && npx create-react-app $$name && cd $$name && code .; \
	else \
		echo "🚀 Creating React project..."; \
		cd ~/Projects/frontend && npx create-react-app $$name && cd $$name && code .; \
	fi

create-vue:
	@read -p "Enter project name: " name; \
	if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🚀 Creating Vue project in WSL environment..."; \
		mkdir -p ~/Projects/frontend && cd ~/Projects/frontend && npm create vue@latest $$name && cd $$name && code .; \
	else \
		echo "🚀 Creating Vue project..."; \
		cd ~/Projects/frontend && npm create vue@latest $$name && cd $$name && code .; \
	fi

create-node:
	@read -p "Enter project name: " name; \
	if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🚀 Creating Node.js project in WSL environment..."; \
		mkdir -p ~/Projects/backend && cd ~/Projects/backend && mkdir $$name && cd $$name && npm init -y && echo "node_modules/\n.env\n*.log" > .gitignore && code .; \
	else \
		echo "🚀 Creating Node.js project..."; \
		cd ~/Projects/backend && mkdir $$name && cd $$name && npm init -y && echo "node_modules/\n.env\n*.log" > .gitignore && code .; \
	fi

create-python:
	@read -p "Enter project name: " name; \
	if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🚀 Creating Python project in WSL environment..."; \
		mkdir -p ~/Projects/backend && cd ~/Projects/backend && mkdir $$name && cd $$name && python3 -m venv .venv && echo ".venv/\n*.pyc\n__pycache__/\n.env" > .gitignore && touch requirements.txt && code .; \
	else \
		echo "🚀 Creating Python project..."; \
		cd ~/Projects/backend && mkdir $$name && cd $$name && python3 -m venv .venv && echo ".venv/\n*.pyc\n__pycache__/\n.env" > .gitignore && touch requirements.txt && code .; \
	fi

# WSL-specific targets
wsl-check:
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "✅ Running in WSL environment"; \
		echo "Distribution: $$(lsb_release -d | cut -f2 2>/dev/null || echo 'Unknown')"; \
		echo "Kernel: $$(uname -r)"; \
		echo "WSL Version: $$(cat /proc/version | grep -oP 'WSL\d?' 2>/dev/null || echo 'WSL 1')"; \
	else \
		echo "❌ Not running in WSL environment"; \
		echo "This is a native Ubuntu installation"; \
	fi

wsl-setup:
	@echo "🔧 Setting up WSL-specific configuration..."
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		chmod +x wsl_advanced_setup.sh; \
		./wsl_advanced_setup.sh; \
	else \
		echo "❌ This command is only for WSL environments"; \
		exit 1; \
	fi

wsl-services:
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🔍 Checking WSL services status..."; \
		echo "MySQL: $$(sudo service mysql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"; \
		echo "PostgreSQL: $$(sudo service postgresql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"; \
		echo "Redis: $$(sudo service redis-server status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not installed')"; \
		echo ""; \
		echo "💡 WSL Service Commands:"; \
		echo "  Start all: sudo service mysql start && sudo service postgresql start && sudo service redis-server start"; \
		echo "  Stop all:  sudo service mysql stop && sudo service postgresql stop && sudo service redis-server stop"; \
	else \
		echo "❌ This command is only for WSL environments"; \
	fi

wsl-restart:
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "🔄 Restarting WSL..."; \
		echo "Run this command from Windows PowerShell/CMD: wsl --shutdown"; \
		echo "Then reopen your WSL terminal"; \
	else \
		echo "❌ This command is only for WSL environments"; \
	fi

# Development service management
dev-start:
	@echo "🚀 Starting development services..."
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "WSL environment detected - starting services..."; \
		sudo service mysql start 2>/dev/null && echo "✅ MySQL started" || echo "❌ MySQL failed to start"; \
		sudo service postgresql start 2>/dev/null && echo "✅ PostgreSQL started" || echo "❌ PostgreSQL failed to start"; \
		sudo service redis-server start 2>/dev/null && echo "✅ Redis started" || echo "❌ Redis failed to start"; \
	else \
		echo "Native Ubuntu detected - starting services..."; \
		sudo systemctl start mysql 2>/dev/null && echo "✅ MySQL started" || echo "❌ MySQL failed to start"; \
		sudo systemctl start postgresql 2>/dev/null && echo "✅ PostgreSQL started" || echo "❌ PostgreSQL failed to start"; \
		sudo systemctl start redis-server 2>/dev/null && echo "✅ Redis started" || echo "❌ Redis failed to start"; \
	fi
	@echo "🎉 Development services startup completed!"

dev-stop:
	@echo "🛑 Stopping development services..."
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "WSL environment detected - stopping services..."; \
		sudo service mysql stop 2>/dev/null && echo "✅ MySQL stopped" || echo "❌ MySQL failed to stop"; \
		sudo service postgresql stop 2>/dev/null && echo "✅ PostgreSQL stopped" || echo "❌ PostgreSQL failed to stop"; \
		sudo service redis-server stop 2>/dev/null && echo "✅ Redis stopped" || echo "❌ Redis failed to stop"; \
	else \
		echo "Native Ubuntu detected - stopping services..."; \
		sudo systemctl stop mysql 2>/dev/null && echo "✅ MySQL stopped" || echo "❌ MySQL failed to stop"; \
		sudo systemctl stop postgresql 2>/dev/null && echo "✅ PostgreSQL stopped" || echo "❌ PostgreSQL failed to stop"; \
		sudo systemctl stop redis-server 2>/dev/null && echo "✅ Redis stopped" || echo "❌ Redis failed to stop"; \
	fi
	@echo "🎉 Development services stopped!"

dev-status:
	@echo "📊 Checking development services status..."
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "WSL environment detected:"; \
		echo "MySQL: $$(sudo service mysql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not running')"; \
		echo "PostgreSQL: $$(sudo service postgresql status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not running')"; \
		echo "Redis: $$(sudo service redis-server status 2>/dev/null | grep -o 'Active: [^)]*' || echo 'Not running')"; \
	else \
		echo "Native Ubuntu detected:"; \
		echo "MySQL: $$(sudo systemctl is-active mysql 2>/dev/null || echo 'Not running')"; \
		echo "PostgreSQL: $$(sudo systemctl is-active postgresql 2>/dev/null || echo 'Not running')"; \
		echo "Redis: $$(sudo systemctl is-active redis-server 2>/dev/null || echo 'Not running')"; \
	fi

# Enhanced system information
info:
	@echo "🖥️  System Information"
	@echo "====================="
	@echo "OS: $$(lsb_release -d | cut -f2 2>/dev/null || echo 'Unknown')"
	@echo "Kernel: $$(uname -r)"
	@echo "Architecture: $$(uname -m)"
	@echo "CPU Cores: $$(nproc)"
	@echo "Memory: $$(free -h | awk '/^Mem:/ {print $$2}') total"
	@echo "Disk: $$(df -h / | awk 'NR==2 {print $$4}') free"
	@echo "Shell: $$SHELL"
	@echo "User: $$USER"
	@if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then \
		echo "Environment: WSL ($$(cat /proc/version | grep -oP 'WSL\d?' 2>/dev/null || echo 'WSL 1'))"; \
	else \
		echo "Environment: Native Ubuntu"; \
	fi
	@echo ""
	@echo "🛠️  Development Tools"
	@echo "===================="
	@echo "Git: $$(git --version 2>/dev/null || echo 'Not installed')"
	@echo "Node.js: $$(node --version 2>/dev/null || echo 'Not installed')"
	@echo "npm: $$(npm --version 2>/dev/null || echo 'Not installed')"
	@echo "Python: $$(python3 --version 2>/dev/null || echo 'Not installed')"
	@echo "Docker: $$(docker --version 2>/dev/null || echo 'Not installed')"
	@echo "VS Code: $$(code --version 2>/dev/null | head -1 || echo 'Not installed')"

# Maintenance and cleanup
maintenance:
	@echo "🧹 Running system maintenance..."
	@echo "Updating package lists..."
	@sudo apt update
	@echo "Upgrading packages..."
	@sudo apt upgrade -y
	@echo "Cleaning up packages..."
	@sudo apt autoremove -y
	@sudo apt autoclean
	@if command -v npm >/dev/null 2>&1; then \
		echo "Cleaning npm cache..."; \
		npm cache clean --force 2>/dev/null || true; \
	fi
	@if command -v pip3 >/dev/null 2>&1; then \
		echo "Cleaning pip cache..."; \
		pip3 cache purge 2>/dev/null || true; \
	fi
	@if command -v docker >/dev/null 2>&1; then \
		echo "Cleaning Docker..."; \
		docker system prune -f 2>/dev/null || true; \
	fi
	@echo "✅ Maintenance completed!"

# Enhanced backup functionality
backup:
	@echo "📦 Creating configuration backup..."
	@mkdir -p ~/Backups/MyConfig_$$(date +%Y%m%d_%H%M%S)
	@BACKUP_DIR=~/Backups/MyConfig_$$(date +%Y%m%d_%H%M%S); \
	cp ~/.vimrc $$BACKUP_DIR/ 2>/dev/null || true; \
	cp ~/.zshrc $$BACKUP_DIR/ 2>/dev/null || true; \
	cp ~/.aliases.zsh $$BACKUP_DIR/ 2>/dev/null || true; \
	cp ~/.wsl_dev_aliases.zsh $$BACKUP_DIR/ 2>/dev/null || true; \
	mkdir -p $$BACKUP_DIR/vscode 2>/dev/null || true; \
	cp ~/.config/Code/User/settings.json $$BACKUP_DIR/vscode/ 2>/dev/null || true; \
	cp ~/.config/Code/User/keybindings.json $$BACKUP_DIR/vscode/ 2>/dev/null || true; \
	echo "✅ Backup created at: $$BACKUP_DIR"

restore:
	@echo "🔄 Available backups:"
	@ls -la ~/Backups/ 2>/dev/null || (echo "❌ No backups found" && exit 1)
	@read -p "Enter backup folder name: " backup; \
	if [ -d ~/Backups/$$backup ]; then \
		echo "Restoring from $$backup..."; \
		cp ~/Backups/$$backup/.vimrc ~/ 2>/dev/null || true; \
		cp ~/Backups/$$backup/.zshrc ~/ 2>/dev/null || true; \
		cp ~/Backups/$$backup/.aliases.zsh ~/ 2>/dev/null || true; \
		cp ~/Backups/$$backup/.wsl_dev_aliases.zsh ~/ 2>/dev/null || true; \
		cp ~/Backups/$$backup/vscode/settings.json ~/.config/Code/User/ 2>/dev/null || true; \
		cp ~/Backups/$$backup/vscode/keybindings.json ~/.config/Code/User/ 2>/dev/null || true; \
		echo "✅ Restore completed from $$backup"; \
	else \
		echo "❌ Backup folder not found"; \
	fi

# Quick environment validation
validate:
	@echo "🔍 Running quick environment validation..."
	@chmod +x validate_setup.sh
	@./validate_setup.sh
