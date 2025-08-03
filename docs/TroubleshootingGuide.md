# 🛠️ Troubleshooting Guide - MyConfig

## 🚨 Common Issues & Solutions

### 🐳 Docker Issues

#### Docker Permission Denied
```bash
# Problem: docker: permission denied
# Solution:
sudo usermod -aG docker $USER
# Then logout and login again, or:
newgrp docker
```

#### Docker Daemon Not Running (WSL)
```bash
# Problem: Cannot connect to Docker daemon
# Check if Docker Desktop is running on Windows
# Solution for WSL:
1. Start Docker Desktop on Windows
2. Enable WSL integration in Docker Desktop settings
3. Restart WSL: wsl --shutdown (from Windows CMD)
```

#### Docker Compose Not Found
```bash
# Problem: docker-compose command not found
# Solution:
sudo apt install docker-compose-plugin
# Or use: docker compose (space, not hyphen)
```

### 🗃️ Database Issues

#### MySQL Won't Start (WSL)
```bash
# Problem: mysql service failed to start
# Solution:
sudo service mysql status
sudo service mysql start

# If still fails:
sudo mysqld_safe --skip-grant-tables &
sudo mysql -u root
# Then reset password and restart normally
```

#### PostgreSQL Connection Issues
```bash
# Problem: could not connect to server
# Solution:
sudo service postgresql start
sudo service postgresql status

# If authentication fails:
sudo -u postgres psql
\password postgres
# Set new password
```

#### Redis Connection Refused
```bash
# Problem: Could not connect to Redis
# Solution:
sudo service redis-server start
redis-cli ping
# Should return PONG

# If still fails:
sudo systemctl status redis-server
sudo systemctl enable redis-server
```

### 💻 VS Code Issues

#### VS Code Command Not Found (WSL)
```bash
# Problem: 'code' command not working in WSL
# Solution:
1. Install VS Code on Windows
2. Install "Remote - WSL" extension
3. Open WSL terminal and run: code .
# VS Code should auto-install WSL server
```

#### Extensions Not Working in WSL
```bash
# Problem: Extensions not loading in WSL
# Solution:
1. Install extensions in WSL context (not Windows)
2. Some extensions need to be installed in both contexts
3. Reload window: Ctrl+Shift+P → "Developer: Reload Window"
```

#### Settings Not Syncing
```bash
# Problem: VS Code settings not applying
# Solution:
cp vscode/settings.json ~/.config/Code/User/
cp vscode/keybindings.json ~/.config/Code/User/
# Or for WSL:
cp vscode/settings.json ~/.vscode-server/data/Machine/
```

### 🔧 Vim Issues

#### Vim Plugins Not Working
```bash
# Problem: NERDTree or other plugins not loaded
# Solution:
vim
:PlugInstall
# Wait for installation to complete
:source ~/.vimrc
```

#### Colorscheme Not Found
```bash
# Problem: monokai colorscheme not found
# Solution:
curl -fLo ~/.vim/colors/monokai.vim --create-dirs \
    https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim
```

#### Key Mappings Not Working
```bash
# Problem: Custom key mappings (jk, Space+n) not working
# Solution:
vim ~/.vimrc
# Check if mappings are properly set:
# let mapleader = " "
# inoremap jk <esc>
:source ~/.vimrc
```

### 🐚 Shell Issues

#### Zsh Not Default Shell
```bash
# Problem: Still using bash instead of zsh
# Solution:
chsh -s $(which zsh)
# Logout and login again
```

#### Oh My Zsh Not Loaded
```bash
# Problem: Plain zsh without Oh My Zsh
# Solution:
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Reload terminal
```

#### Aliases Not Working
```bash
# Problem: Custom aliases not available
# Solution:
echo "source ~/.aliases.zsh" >> ~/.zshrc
source ~/.zshrc

# For WSL specific aliases:
echo "source ~/.wsl_dev_aliases.zsh" >> ~/.zshrc
source ~/.zshrc
```

### 🌐 Node.js Issues

#### Node Version Issues
```bash
# Problem: Wrong Node.js version or not found
# Solution:
# Remove old versions:
sudo apt remove nodejs npm

# Install latest LTS:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# Verify:
node --version
npm --version
```

#### npm Permission Issues
```bash
# Problem: npm EACCES permission errors
# Solution:
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

#### Yarn Not Found
```bash
# Problem: yarn command not found
# Solution:
sudo npm install -g yarn
# Or via apt:
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```

### 🐍 Python Issues

#### pip3 Not Found
```bash
# Problem: pip3 command not found
# Solution:
sudo apt install python3-pip
# Or:
python3 -m ensurepip --upgrade
```

#### Virtual Environment Issues
```bash
# Problem: venv not working
# Solution:
sudo apt install python3-venv
python3 -m venv myenv
source myenv/bin/activate

# Or use virtualenv:
pip3 install virtualenv
virtualenv myenv
```

#### Module Import Errors
```bash
# Problem: ModuleNotFoundError
# Solution:
# Make sure you're in correct virtual environment
which python3
pip3 list
# Install missing modules:
pip3 install module_name
```

### 🔄 WSL Specific Issues

#### WSL Services Not Starting
```bash
# Problem: systemctl not available in WSL
# Solution: Use service command instead
sudo service mysql start
sudo service postgresql start
sudo service redis-server start

# NOT: systemctl (doesn't work in WSL 1)
```

#### Windows Path Issues
```bash
# Problem: Can't access Windows files
# Solution:
cd /mnt/c/Users/yourusername
# Or use aliases:
to-windows-path /home/user/project
to-wsl-path C:\Users\project
```

#### WSL 1 vs WSL 2 Issues
```bash
# Check WSL version:
wsl -l -v

# Upgrade to WSL 2 (from Windows):
wsl --set-version Ubuntu 2

# WSL 2 benefits: Better Docker support, faster file I/O
```

### 📦 Package Manager Issues

#### apt update Errors
```bash
# Problem: apt update fails with errors
# Solution:
sudo apt clean
sudo apt autoclean
sudo apt update --fix-missing
sudo apt install -f
```

#### Broken Dependencies
```bash
# Problem: The following packages have unmet dependencies
# Solution:
sudo apt --fix-broken install
sudo apt autoremove
sudo apt autoclean
```

### 🔍 Diagnostic Commands

#### Environment Check
```bash
# Quick environment validation:
./validate_simple.sh

# Full environment check:
make check

# WSL specific check:
make wsl-check

# Individual checks:
which git vim node python3 docker
```

#### Service Status
```bash
# Check all services (WSL):
sudo service --status-all

# Individual service check:
sudo service mysql status
sudo service postgresql status
sudo service redis-server status
```

#### Log Analysis
```bash
# System logs:
journalctl -xe

# Service specific logs:
sudo journalctl -u mysql
sudo journalctl -u postgresql

# WSL logs:
dmesg | tail
```

## 🆘 Reset & Recovery

### Complete Reset
```bash
# WARNING: This will remove all configurations
# Backup first:
cp ~/.vimrc ~/.vimrc.backup
cp ~/.zshrc ~/.zshrc.backup

# Then run fresh setup:
./auto_setup.sh
```

### Partial Reset

#### Reset Vim Only
```bash
rm -rf ~/.vim
rm ~/.vimrc
./setup_vim.sh
```

#### Reset VS Code Only
```bash
rm -rf ~/.config/Code/User/
cp vscode/settings.json ~/.config/Code/User/
cp vscode/keybindings.json ~/.config/Code/User/
```

#### Reset Shell Only
```bash
rm ~/.zshrc
rm ~/.aliases.zsh
# Then re-run zsh setup part of auto_setup.sh
```

## 📞 Getting Help

### Debug Information to Collect
```bash
# System info:
uname -a
lsb_release -a
echo $0

# Environment:
env | grep -E "(PATH|NODE|PYTHON|DOCKER)"

# Versions:
git --version
vim --version
node --version
python3 --version
docker --version
```

### Useful Resources
- **VS Code WSL**: https://code.visualstudio.com/docs/remote/wsl
- **Docker WSL**: https://docs.docker.com/desktop/wsl/
- **Oh My Zsh**: https://ohmyz.sh/
- **Vim Plugins**: https://github.com/junegunn/vim-plug

---

*💡 **Tip**: Always backup your configurations before making major changes!*
