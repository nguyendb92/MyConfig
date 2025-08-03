# =============================================================================
# Makefile for MyConfig - Fullstack Developer Environment Setup
# =============================================================================
# Author: Nguyen DB
# Description: Unified build automation for development environment setup
# Version: 2.0 - Enhanced for Consistency and Usability
# Usage: make [target] - See 'make help' for available targets
# =============================================================================

.PHONY: help install setup-vim setup-vscode install-extensions post-setup check clean validate update backup restore dev-start dev-stop dev-status info wsl-setup wsl-check wsl-services wsl-restart update-aliases

# Include common functions
SHELL := /bin/bash

# Color output for better UX
BLUE := \033[34m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m # No Color

# Helper function to print formatted messages
define log_info
	@echo -e "$(BLUE)[INFO]$(NC) ℹ️  $(1)"
endef

define log_success
	@echo -e "$(GREEN)[SUCCESS]$(NC) ✅ $(1)"
endef

define log_warning
	@echo -e "$(YELLOW)[WARNING]$(NC) ⚠️  $(1)"
endef

define log_error
	@echo -e "$(RED)[ERROR]$(NC) ❌ $(1)"
endef

# =============================================================================
# PRIMARY COMMANDS - Core functionality
# =============================================================================

# Default target - Show help
help:
	@echo -e "$(BLUE)=== 🎯 MyConfig - Fullstack Developer Environment Setup ===$(NC)"
	@echo ""
	@echo -e "$(GREEN)📋 Core Commands:$(NC)"
	@echo "  make install          - 🚀 Full automated installation (recommended)"
	@echo "  make setup-vim        - ⚡ Setup Vim configuration only"
	@echo "  make setup-vscode     - 🎨 Setup VS Code configuration only"
	@echo "  make install-ext      - 🔌 Install VS Code extensions only"
	@echo "  make post-setup       - ⚙️  Run post-installation configuration"
	@echo "  make update-aliases   - 🔄 Update aliases"
	@echo ""
	@echo -e "$(GREEN)🔍 Validation & Maintenance:$(NC)"
	@echo "  make validate         - ✅ Comprehensive environment validation"
	@echo "  make check            - 🔧 Quick environment check"
	@echo "  make update           - 📦 Update all tools and packages"
	@echo "  make backup           - 💾 Backup current configurations"
	@echo "  make restore          - 🔄 Restore configurations from backup"
	@echo "  make clean            - 🧹 Clean up temporary files"
	@echo "  make info             - 📊 Show system information"
	@echo ""
	@echo -e "$(GREEN)🚀 Development Services:$(NC)"
	@echo "  make dev-start        - ▶️  Start development services"
	@echo "  make dev-stop         - ⏹️  Stop development services"
	@echo "  make dev-status       - 📋 Check services status"
	@echo ""
	@echo -e "$(GREEN)🐧 WSL-specific Commands:$(NC)"
	@echo "  make wsl-setup        - 🐧 WSL-specific advanced setup"
	@echo "  make wsl-check        - 🔍 Check if running in WSL"
	@echo "  make wsl-services     - ⚙️  Manage WSL services"
	@echo ""
	@echo -e "$(GREEN)⚡ Quick Start:$(NC)"
	@echo "  🐧 Ubuntu: make install && make post-setup"
	@echo "  🪟 WSL:    make install && make wsl-setup"
	@echo ""
	@echo -e "$(GREEN)💡 Tips:$(NC)"
	@echo "  - Use 'make validate' to check current setup"
	@echo "  - Run 'make clean' before major updates"
	@echo "  - Use 'make backup' before making changes"

# Full installation process
install:
	$(call log_info,"Starting full MyConfig installation...")
	@chmod +x auto_setup.sh validate_setup.sh
	@./auto_setup.sh

# =============================================================================
# COMPONENT SETUP - Individual components
# =============================================================================

# Setup Vim configuration
setup-vim:
	$(call log_info,"Setting up Vim configuration...")
	@chmod +x setup_vim.sh
	@./setup_vim.sh

# Setup VS Code configuration
setup-vscode:
	$(call log_info,"Setting up VS Code configuration...")
	@if [ -d "vscode" ]; then \
		mkdir -p ~/.config/Code/User; \
		cp vscode/settings.json ~/.config/Code/User/ 2>/dev/null || true; \
		cp vscode/keybindings.json ~/.config/Code/User/ 2>/dev/null || true; \
		$(call log_success,"VS Code configuration updated"); \
	else \
		$(call log_error,"VS Code configuration directory not found"); \
		exit 1; \
	fi

# Install VS Code extensions
install-ext:
	$(call log_info,"Installing VS Code extensions...")
	@chmod +x install_extensions.sh
	@./install_extensions.sh

# Post-installation setup
post-setup:
	$(call log_info,"Running post-installation setup...")
	@chmod +x post_setup.sh
	@./post_setup.sh

# Update aliases
update-aliases:
	$(call log_info,"Updating aliases...")
	@if [ -f ".aliases.zsh" ]; then \
		cp ~/.aliases.zsh ~/.aliases.zsh.backup.$$(date +%Y%m%d_%H%M%S) 2>/dev/null || true; \
		cp .aliases.zsh ~/; \
		$(call log_success,"Aliases updated successfully"); \
		echo "🔄 Reload with: source ~/.zshrc"; \
	else \
		$(call log_error,".aliases.zsh not found in current directory"); \
		exit 1; \
	fi

# =============================================================================
# VALIDATION & MAINTENANCE - System checking and maintenance
# =============================================================================

# Comprehensive validation
validate:
	$(call log_info,"Running comprehensive validation...")
	@chmod +x validate_standalone.sh
	@./validate_standalone.sh

# Quick environment check
check:
	$(call log_info,"Running quick environment check...")
	@chmod +x check_environment.sh
	@./check_environment.sh

# Update system and tools
update:
	$(call log_info,"Updating system and tools...")
	@sudo apt update && sudo apt upgrade -y
	@if command -v npm >/dev/null 2>&1; then sudo npm update -g; fi
	@if command -v pip3 >/dev/null 2>&1; then pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 2>/dev/null || true; fi
	$(call log_success,"System update completed")

# System information
info:
	$(call log_info,"Gathering system information...")
	@echo -e "$(BLUE)🖥️  System Information$(NC)"
	@echo "══════════════════════"
	@echo "OS: $$(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
	@echo "Kernel: $$(uname -r)"
	@echo "Architecture: $$(uname -m)"
	@echo "Shell: $$SHELL"
	@echo "User: $$USER"
	@echo "Home: $$HOME"
	@echo ""
	@echo -e "$(BLUE)💾 Memory & Storage$(NC)"
	@echo "══════════════════════"
	@echo "Memory: $$(free -h | awk '/^Mem:/ {print $$3 "/" $$2}')"
	@echo "Disk: $$(df -h / | awk 'NR==2 {print $$3 "/" $$2 " (" $$5 " used)"}')"
	@echo ""
	@echo -e "$(BLUE)🔧 Development Tools$(NC)"
	@echo "══════════════════════"
	@if command -v git >/dev/null 2>&1; then echo "Git: $$(git --version | cut -d' ' -f3)"; else echo "Git: Not installed"; fi
	@if command -v node >/dev/null 2>&1; then echo "Node.js: $$(node --version)"; else echo "Node.js: Not installed"; fi
	@if command -v python3 >/dev/null 2>&1; then echo "Python3: $$(python3 --version | cut -d' ' -f2)"; else echo "Python3: Not installed"; fi
	@if command -v docker >/dev/null 2>&1; then echo "Docker: $$(docker --version | cut -d' ' -f3 | tr -d ',')"; else echo "Docker: Not installed"; fi
	@if command -v code >/dev/null 2>&1; then echo "VS Code: $$(code --version | head -n1)"; else echo "VS Code: Not installed"; fi

# =============================================================================
# DEVELOPMENT SERVICES - Service management
# =============================================================================

# Start development services
dev-start:
	$(call log_info,"Starting development services...")
	@echo "🔧 Checking environment..."
	@if [ -f /proc/version ] && grep -qi "microsoft\|wsl" /proc/version; then \
		echo "🐧 WSL Environment detected"; \
		sudo service mysql start 2>/dev/null || true; \
		sudo service postgresql start 2>/dev/null || true; \
		sudo service redis-server start 2>/dev/null || true; \
	else \
		echo "🐧 Native Ubuntu detected"; \
		sudo systemctl start mysql 2>/dev/null || true; \
		sudo systemctl start postgresql 2>/dev/null || true; \
		sudo systemctl start redis-server 2>/dev/null || true; \
	fi
	@if command -v docker >/dev/null 2>&1; then \
		sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null || true; \
	fi
	$(call log_success,"Development services started")

# Stop development services
dev-stop:
	$(call log_info,"Stopping development services...")
	@if [ -f /proc/version ] && grep -qi "microsoft\|wsl" /proc/version; then \
		sudo service mysql stop 2>/dev/null || true; \
		sudo service postgresql stop 2>/dev/null || true; \
		sudo service redis-server stop 2>/dev/null || true; \
	else \
		sudo systemctl stop mysql 2>/dev/null || true; \
		sudo systemctl stop postgresql 2>/dev/null || true; \
		sudo systemctl stop redis-server 2>/dev/null || true; \
	fi
	@if command -v docker >/dev/null 2>&1; then \
		sudo systemctl stop docker 2>/dev/null || sudo service docker stop 2>/dev/null || true; \
	fi
	$(call log_success,"Development services stopped")

# Check development services status
dev-status:
	$(call log_info,"Checking development services status...")
	@echo "🔧 Service Status:"
	@if [ -f /proc/version ] && grep -qi "microsoft\|wsl" /proc/version; then \
		echo -n "  MySQL: "; sudo service mysql status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  PostgreSQL: "; sudo service postgresql status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  Redis: "; sudo service redis-server status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
	else \
		echo -n "  MySQL: "; systemctl is-active mysql >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  PostgreSQL: "; systemctl is-active postgresql >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  Redis: "; systemctl is-active redis-server >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
	fi
	@if command -v docker >/dev/null 2>&1; then \
		echo -n "  Docker: "; docker ps >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
	fi

# =============================================================================
# WSL-SPECIFIC COMMANDS - Windows Subsystem for Linux
# =============================================================================

# WSL advanced setup
wsl-setup:
	$(call log_info,"Running WSL-specific setup...")
	@chmod +x wsl_advanced_setup.sh
	@./wsl_advanced_setup.sh

# Check if running in WSL
wsl-check:
	@if [ -f /proc/version ] && grep -qi "microsoft\|wsl" /proc/version; then \
		echo -e "$(GREEN)✅ Running in WSL environment$(NC)"; \
		echo "WSL Version: $$(cat /proc/version | grep -oP 'WSL\d?' 2>/dev/null || echo 'WSL 1')"; \
	else \
		echo -e "$(YELLOW)⚠️  Not running in WSL$(NC)"; \
	fi

# WSL service management
wsl-services:
	$(call log_info,"Managing WSL services...")
	@if [ -f /proc/version ] && grep -qi "microsoft\|wsl" /proc/version; then \
		echo "🔧 WSL Service Status:"; \
		echo -n "  SSH: "; sudo service ssh status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  MySQL: "; sudo service mysql status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  PostgreSQL: "; sudo service postgresql status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
		echo -n "  Redis: "; sudo service redis-server status >/dev/null 2>&1 && echo -e "$(GREEN)✅ Running$(NC)" || echo -e "$(RED)❌ Stopped$(NC)"; \
	else \
		$(call log_warning,"Not in WSL environment"); \
	fi

# =============================================================================
# BACKUP & RESTORE - Configuration management
# =============================================================================

# Backup configurations
backup:
	$(call log_info,"Creating backup of configurations...")
	@mkdir -p ~/.myconfig/backups
	@backup_date=$$(date +%Y%m%d_%H%M%S); \
	backup_dir="$$HOME/.myconfig/backups/myconfig_backup_$$backup_date"; \
	mkdir -p "$$backup_dir"; \
	echo "📦 Creating backup in: $$backup_dir"; \
	cp ~/.vimrc "$$backup_dir/" 2>/dev/null || true; \
	cp ~/.zshrc "$$backup_dir/" 2>/dev/null || true; \
	cp ~/.aliases.zsh "$$backup_dir/" 2>/dev/null || true; \
	cp -r ~/.config/Code/User "$$backup_dir/vscode" 2>/dev/null || true; \
	cp ~/.ssh/config "$$backup_dir/" 2>/dev/null || true; \
	echo "$$backup_date" > "$$backup_dir/backup_info.txt"; \
	echo "MyConfig backup created on: $$(date)" >> "$$backup_dir/backup_info.txt"; \
	$(call log_success,"Backup created: $$backup_dir")

# Restore configurations
restore:
	$(call log_info,"Restoring configurations from backup...")
	@if [ -z "$(BACKUP)" ]; then \
		echo -e "$(YELLOW)Available backups:$(NC)"; \
		ls -la ~/.myconfig/backups/ 2>/dev/null | grep "myconfig_backup" || echo "No backups found"; \
		echo ""; \
		echo "Usage: make restore BACKUP=myconfig_backup_YYYYMMDD_HHMMSS"; \
		exit 1; \
	fi
	@backup_dir="$$HOME/.myconfig/backups/$(BACKUP)"; \
	if [ -d "$$backup_dir" ]; then \
		echo "🔄 Restoring from: $$backup_dir"; \
		cp "$$backup_dir/.vimrc" ~/ 2>/dev/null || true; \
		cp "$$backup_dir/.zshrc" ~/ 2>/dev/null || true; \
		cp "$$backup_dir/.aliases.zsh" ~/ 2>/dev/null || true; \
		mkdir -p ~/.config/Code/User; \
		cp -r "$$backup_dir/vscode/"* ~/.config/Code/User/ 2>/dev/null || true; \
		cp "$$backup_dir/config" ~/.ssh/ 2>/dev/null || true; \
		$(call log_success,"Configuration restored from backup"); \
	else \
		$(call log_error,"Backup directory not found: $$backup_dir"); \
		exit 1; \
	fi

# =============================================================================
# MAINTENANCE - Cleanup and utilities
# =============================================================================

# Clean up temporary files
clean:
	$(call log_info,"Cleaning up temporary files...")
	@rm -f *.log *.tmp ~/.myconfig/logs/*.log 2>/dev/null || true
	@find . -name "*.backup_*" -type f -mtime +30 -delete 2>/dev/null || true
	@if command -v docker >/dev/null 2>&1; then \
		docker system prune -f >/dev/null 2>&1 || true; \
	fi
	@if command -v npm >/dev/null 2>&1; then \
		npm cache clean --force >/dev/null 2>&1 || true; \
	fi
	$(call log_success,"Cleanup completed")

# Show version info
version:
	@echo -e "$(BLUE)MyConfig Version 2.0$(NC)"
	@echo "Enhanced for Consistency and Usability"
	@echo "Author: Nguyen DB"
	@echo "Last Updated: $$(date)"
