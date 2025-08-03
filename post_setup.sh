#!/bin/bash

# =============================================================================
# POST SETUP CONFIGURATION SCRIPT
# =============================================================================
# Author: Nguyen DB
# Description: Additional configuration after the main setup
# =============================================================================

# Load common functions and constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || {
    echo "❌ ERROR: Cannot load common library. Please ensure lib/common.sh exists."
    exit 1
}

# Initialize common settings
init_common

log_section() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# Configure MySQL
configure_mysql() {
    log_section "CONFIGURING MYSQL"
    
    if command -v mysql &> /dev/null; then
        log_info "Securing MySQL installation..."
        log_warning "Please follow the prompts to secure your MySQL installation"
        sudo mysql_secure_installation
        
        log_info "Creating development user..."
        read -p "Enter MySQL development username (default: dev): " mysql_user
        mysql_user=${mysql_user:-dev}
        
        read -s -p "Enter password for MySQL user '$mysql_user': " mysql_pass
        echo
        
        sudo mysql -e "CREATE USER IF NOT EXISTS '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_pass';"
        sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$mysql_user'@'localhost' WITH GRANT OPTION;"
        sudo mysql -e "FLUSH PRIVILEGES;"
        
        log_success "MySQL user '$mysql_user' created successfully"
    else
        log_warning "MySQL not found, skipping configuration"
    fi
}

# Configure PostgreSQL
configure_postgresql() {
    log_section "CONFIGURING POSTGRESQL"
    
    if command -v psql &> /dev/null; then
        log_info "Setting up PostgreSQL..."
        
        # Start PostgreSQL service
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
        
        # Create development user
        read -p "Enter PostgreSQL development username (default: dev): " pg_user
        pg_user=${pg_user:-dev}
        
        read -s -p "Enter password for PostgreSQL user '$pg_user': " pg_pass
        echo
        
        sudo -u postgres psql -c "CREATE USER $pg_user WITH PASSWORD '$pg_pass';"
        sudo -u postgres psql -c "ALTER USER $pg_user CREATEDB;"
        sudo -u postgres psql -c "ALTER USER $pg_user WITH SUPERUSER;"
        
        # Create development database
        sudo -u postgres createdb -O $pg_user ${pg_user}_dev
        
        log_success "PostgreSQL user '$pg_user' and database '${pg_user}_dev' created"
    else
        log_warning "PostgreSQL not found, skipping configuration"
    fi
}

# Configure Redis
configure_redis() {
    log_section "CONFIGURING REDIS"
    
    if command -v redis-server &> /dev/null; then
        log_info "Starting Redis service..."
        sudo systemctl start redis-server
        sudo systemctl enable redis-server
        
        # Test Redis connection
        if redis-cli ping > /dev/null 2>&1; then
            log_success "Redis is running and accessible"
        else
            log_warning "Redis service started but may not be accessible"
        fi
    else
        log_warning "Redis not found, skipping configuration"
    fi
}

# Setup SSH key
setup_ssh_key() {
    log_section "SETTING UP SSH KEY"
    
    if [ ! -f "$HOME/.ssh/id_rsa" ]; then
        log_info "Generating SSH key..."
        read -p "Enter your email for SSH key: " ssh_email
        ssh-keygen -t rsa -b 4096 -C "$ssh_email" -f "$HOME/.ssh/id_rsa" -N ""
        
        # Start ssh-agent and add key
        eval "$(ssh-agent -s)"
        ssh-add "$HOME/.ssh/id_rsa"
        
        log_success "SSH key generated successfully"
        log_info "Your public key:"
        cat "$HOME/.ssh/id_rsa.pub"
        log_warning "Copy this key to your Git repositories (GitHub, GitLab, etc.)"
    else
        log_info "SSH key already exists"
        log_info "Your public key:"
        cat "$HOME/.ssh/id_rsa.pub"
    fi
}

# Create useful development scripts
create_dev_scripts() {
    log_section "CREATING DEVELOPMENT SCRIPTS"
    
    local scripts_dir="$HOME/Projects/scripts"
    mkdir -p "$scripts_dir"
    
    # Project starter script
    cat > "$scripts_dir/create-project.sh" << 'EOF'
#!/bin/bash
# Quick project creator

if [ $# -eq 0 ]; then
    echo "Usage: $0 <project-name> [type]"
    echo "Types: react, vue, angular, node, python, django, flask"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_TYPE=${2:-node}
PROJECTS_DIR="$HOME/Projects"

case $PROJECT_TYPE in
    react)
        cd "$PROJECTS_DIR/frontend"
        npx create-react-app "$PROJECT_NAME"
        ;;
    vue)
        cd "$PROJECTS_DIR/frontend"
        npm create vue@latest "$PROJECT_NAME"
        ;;
    angular)
        cd "$PROJECTS_DIR/frontend"
        ng new "$PROJECT_NAME"
        ;;
    node|express)
        cd "$PROJECTS_DIR/backend"
        mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
        npm init -y
        npm install express
        echo "const express = require('express');" > app.js
        echo "const app = express();" >> app.js
        echo "const PORT = process.env.PORT || 3000;" >> app.js
        echo "" >> app.js
        echo "app.get('/', (req, res) => {" >> app.js
        echo "  res.json({ message: 'Hello World!' });" >> app.js
        echo "});" >> app.js
        echo "" >> app.js
        echo "app.listen(PORT, () => {" >> app.js
        echo "  console.log(\`Server running on port \${PORT}\`);" >> app.js
        echo "});" >> app.js
        ;;
    python)
        cd "$PROJECTS_DIR/backend"
        mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
        python3 -m venv .venv
        source .venv/bin/activate
        echo "Flask==2.3.3" > requirements.txt
        pip install -r requirements.txt
        ;;
    django)
        cd "$PROJECTS_DIR/backend"
        mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
        python3 -m venv .venv
        source .venv/bin/activate
        pip install django
        django-admin startproject "$PROJECT_NAME" .
        ;;
    flask)
        cd "$PROJECTS_DIR/backend"
        mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME"
        python3 -m venv .venv
        source .venv/bin/activate
        pip install flask
        echo "from flask import Flask" > app.py
        echo "" >> app.py
        echo "app = Flask(__name__)" >> app.py
        echo "" >> app.py
        echo "@app.route('/')" >> app.py
        echo "def hello():" >> app.py
        echo "    return {'message': 'Hello World!'}" >> app.py
        echo "" >> app.py
        echo "if __name__ == '__main__':" >> app.py
        echo "    app.run(debug=True)" >> app.py
        ;;
    *)
        echo "Unknown project type: $PROJECT_TYPE"
        exit 1
        ;;
esac

echo "Project '$PROJECT_NAME' created successfully!"
echo "Location: $(pwd)/$PROJECT_NAME"
EOF

    chmod +x "$scripts_dir/create-project.sh"
    
    # Database backup script
    cat > "$scripts_dir/backup-db.sh" << 'EOF'
#!/bin/bash
# Database backup utility

BACKUP_DIR="$HOME/backups/databases"
mkdir -p "$BACKUP_DIR"
DATE=$(date +%Y%m%d_%H%M%S)

backup_mysql() {
    local db_name=$1
    local backup_file="$BACKUP_DIR/mysql_${db_name}_${DATE}.sql"
    mysqldump -u root -p "$db_name" > "$backup_file"
    echo "MySQL backup saved: $backup_file"
}

backup_postgresql() {
    local db_name=$1
    local backup_file="$BACKUP_DIR/postgres_${db_name}_${DATE}.sql"
    pg_dump "$db_name" > "$backup_file"
    echo "PostgreSQL backup saved: $backup_file"
}

if [ $# -eq 0 ]; then
    echo "Usage: $0 <mysql|postgres> <database_name>"
    exit 1
fi

case $1 in
    mysql)
        backup_mysql $2
        ;;
    postgres|postgresql)
        backup_postgresql $2
        ;;
    *)
        echo "Unsupported database type: $1"
        exit 1
        ;;
esac
EOF

    chmod +x "$scripts_dir/backup-db.sh"
    
    # System info script
    cat > "$scripts_dir/system-info.sh" << 'EOF'
#!/bin/bash
# Display system information for development

echo "=== SYSTEM INFORMATION ==="
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""

echo "=== DEVELOPMENT TOOLS ==="
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "npm: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
echo "pip: $(pip3 --version 2>/dev/null || echo 'Not installed')"
echo "Git: $(git --version 2>/dev/null || echo 'Not installed')"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo "VS Code: $(code --version 2>/dev/null | head -1 || echo 'Not installed')"
echo ""

echo "=== DATABASES ==="
echo "MySQL: $(mysql --version 2>/dev/null || echo 'Not installed')"
echo "PostgreSQL: $(psql --version 2>/dev/null || echo 'Not installed')"
echo "Redis: $(redis-server --version 2>/dev/null || echo 'Not installed')"
echo ""

echo "=== SERVICES STATUS ==="
systemctl is-active mysql 2>/dev/null && echo "MySQL: Active" || echo "MySQL: Inactive"
systemctl is-active postgresql 2>/dev/null && echo "PostgreSQL: Active" || echo "PostgreSQL: Inactive"
systemctl is-active redis-server 2>/dev/null && echo "Redis: Active" || echo "Redis: Inactive"
systemctl is-active docker 2>/dev/null && echo "Docker: Active" || echo "Docker: Inactive"
EOF

    chmod +x "$scripts_dir/system-info.sh"
    
    # Add scripts to PATH by updating .zshrc
    if ! grep -q "$scripts_dir" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# Add custom scripts to PATH" >> "$HOME/.zshrc"
        echo "export PATH=\"$scripts_dir:\$PATH\"" >> "$HOME/.zshrc"
    fi
    
    log_success "Development scripts created in $scripts_dir"
}

# Main execution
main() {
    log_section "POST SETUP CONFIGURATION"
    log_info "Performing additional configuration..."
    
    configure_mysql
    configure_postgresql
    configure_redis
    setup_ssh_key
    create_dev_scripts
    
    log_section "POST SETUP COMPLETED!"
    log_success "Your development environment is fully configured!"
    log_info "Run 'source ~/.zshrc' to reload your shell configuration"
}

# Run main function
main "$@"
