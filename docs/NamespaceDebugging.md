# Namespace Debugging System

## 📋 Tổng quan

Hệ thống namespace debugging giúp fullstack developers quản lý và dọn dẹp debug logs một cách hiệu quả thông qua việc sử dụng namespace để phân loại và tìm kiếm logs.

## 🎯 Ý tưởng cốt lõi

### Namespace Convention
```
[NAMESPACE:LEVEL] Message
[NNC-NAMESPACE:LEVEL] Message (Personalized version)
```

**Ví dụ:**
- `[AUTH:ERROR]` - Authentication errors (generic)
- `[NNC-AUTH:ERROR]` - Authentication errors (personalized)
- `[API:DEBUG]` - API debugging (generic) 
- `[NNC-API:DEBUG]` - API debugging (personalized)
- `[NNC-TEMP:INFO]` - Temporary info logs (personalized)

## 🔧 Implementation

### JavaScript/TypeScript

#### 1. Debug Logger Class
```javascript
class NamespaceLogger {
    constructor(namespace, enabled = process.env.NODE_ENV !== 'production') {
        this.namespace = namespace;
        this.enabled = enabled;
    }

    log(level, message, ...args) {
        if (!this.enabled) return;
        const timestamp = new Date().toISOString();
        const prefix = `[${this.namespace}:${level.toUpperCase()}]`;
        console.log(`${timestamp} ${prefix}`, message, ...args);
    }

    debug(message, ...args) { this.log('debug', message, ...args); }
    info(message, ...args) { this.log('info', message, ...args); }
    warn(message, ...args) { this.log('warn', message, ...args); }
    error(message, ...args) { this.log('error', message, ...args); }
}

// Usage
const authLogger = new NamespaceLogger('AUTH');
const dbLogger = new NamespaceLogger('DB');
const apiLogger = new NamespaceLogger('API');

authLogger.error('Login failed for user:', userId);
dbLogger.info('Database connection established');
apiLogger.debug('API request:', request.url);
```

#### 2. Simple Namespace Functions
```javascript
// Simple namespace functions
const createLogger = (namespace) => ({
    debug: (msg, ...args) => console.log(`[${namespace}:DEBUG]`, msg, ...args),
    info: (msg, ...args) => console.log(`[${namespace}:INFO]`, msg, ...args),
    warn: (msg, ...args) => console.log(`[${namespace}:WARN]`, msg, ...args),
    error: (msg, ...args) => console.log(`[${namespace}:ERROR]`, msg, ...args),
});

```javascript
// Usage
const log = {
    auth: createLogger('AUTH'),        // Generic
    nnc_auth: createLogger('NNC-AUTH'), // Personalized
    api: createLogger('API'),          // Generic
    nnc_api: createLogger('NNC-API'),   // Personalized
    db: createLogger('DB'),
    ui: createLogger('UI'),
};

log.auth.error('Invalid credentials');
log.nnc_auth.error('NNC: Invalid credentials');  // Personalized
log.nnc_api.debug('NNC: Response data:', data);  // Personalized
```
```

### Python

#### 1. Python Logger Class
```python
import logging
from datetime import datetime
import os

class NamespaceLogger:
    def __init__(self, namespace, enabled=None):
        self.namespace = namespace
        self.enabled = enabled if enabled is not None else os.getenv('DEBUG', 'false').lower() == 'true'
    
    def _log(self, level, message, *args):
        if not self.enabled:
            return
        timestamp = datetime.now().isoformat()
        prefix = f"[{self.namespace}:{level.upper()}]"
        print(f"{timestamp} {prefix} {message}", *args)
    
    def debug(self, message, *args):
        self._log('debug', message, *args)
    
    def info(self, message, *args):
        self._log('info', message, *args)
    
    def warn(self, message, *args):
        self._log('warn', message, *args)
    
    def error(self, message, *args):
        self._log('error', message, *args)

# Usage
auth_logger = NamespaceLogger('AUTH')
db_logger = NamespaceLogger('DB')
api_logger = NamespaceLogger('API')

auth_logger.error('Login failed for user:', user_id)
db_logger.info('Database connection established')
api_logger.debug('API request:', request.url)
```

#### 2. Simple Python Functions
```python
def create_logger(namespace):
    return {
        'debug': lambda msg, *args: print(f"[{namespace}:DEBUG]", msg, *args),
        'info': lambda msg, *args: print(f"[{namespace}:INFO]", msg, *args),
        'warn': lambda msg, *args: print(f"[{namespace}:WARN]", msg, *args),
        'error': lambda msg, *args: print(f"[{namespace}:ERROR]", msg, *args),
    }

# Usage
log = {
    'auth': create_logger('AUTH'),
    'db': create_logger('DB'),
    'api': create_logger('API'),
    'ui': create_logger('UI'),
}

log['auth']['error']('Invalid credentials')
log['db']['info']('Query executed successfully')
log['api']['debug']('Response data:', data)
```

## 🏷️ Personalized Namespaces (NNC)

### NNC Namespace System
MyConfig hỗ trợ personalized namespaces với prefix "NNC" (có thể customize theo tên bạn):

#### Available NNC Namespaces:
- `NNC-AUTH` - Authentication & Authorization
- `NNC-API` - API calls and responses  
- `NNC-DB` - Database operations
- `NNC-UI` - User Interface components
- `NNC-TEMP` - Temporary debugging
- `NNC-PERF` - Performance monitoring
- `NNC-CACHE` - Caching operations
- `NNC-QUEUE` - Queue operations
- `NNC-DEPLOY` - Deployment processes
- `NNC-TEST` - Testing & QA

#### NNC Usage Examples:
```javascript
// JavaScript/TypeScript
const nncLog = {
    auth: (msg, data) => console.log(`[NNC-AUTH:DEBUG] ${msg}`, data),
    api: (msg, data) => console.log(`[NNC-API:INFO] ${msg}`, data),
    temp: (msg, data) => console.log(`[NNC-TEMP:DEBUG] ${msg}`, data)
};

nncLog.auth('User login attempt', { userId: 123 });
nncLog.api('API response received', responseData);
nncLog.temp('Temporary debug info', debugData);
```

```python
# Python
class NNCLogger:
    @staticmethod
    def auth_debug(msg, *args):
        print(f"[NNC-AUTH:DEBUG] {msg}", *args)
    
    @staticmethod  
    def api_info(msg, *args):
        print(f"[NNC-API:INFO] {msg}", *args)
        
    @staticmethod
    def temp_debug(msg, *args):
        print(f"[NNC-TEMP:DEBUG] {msg}", *args)

# Usage
NNCLogger.auth_debug('Processing login', user_data)
NNCLogger.api_info('Database query completed', result_count)
NNCLogger.temp_debug('Temporary debug point', variable_value)
```

### NNC Quick Commands:
```bash
# View all NNC namespaces
nnc-namespaces

# Find specific NNC logs
nnc-debug-auth      # Find NNC-AUTH logs
nnc-debug-api       # Find NNC-API logs
nnc-debug-temp      # Find NNC-TEMP logs

# Clean up NNC logs
nnc-clean-auth      # Preview NNC-AUTH cleanup
nnc-clean-all       # Preview all NNC cleanup

# Project analysis
nnc-project-debug   # Analyze NNC logs in current project

# Get help
nnc-help           # Show NNC-specific help
```

## 🗂️ Common Namespaces

### Frontend
- `UI` - User Interface components
- `API` - API calls and responses
- `AUTH` - Authentication/Authorization
- `ROUTER` - Routing and navigation
- `STATE` - State management
- `FORM` - Form validation and submission

### Backend
- `AUTH` - Authentication middleware
- `DB` - Database operations
- `API` - API endpoints
- `MIDDLEWARE` - Middleware functions
- `CACHE` - Caching operations
- `QUEUE` - Job queue operations

### DevOps
- `DOCKER` - Container operations
- `DEPLOY` - Deployment processes
- `MONITOR` - Monitoring and metrics
- `BACKUP` - Backup operations

## 🛠️ Log Management Tools

### Bash Functions (sẽ được thêm vào .aliases.zsh)

```bash
# Find logs by namespace
find-logs() {
    local namespace=$1
    local file=${2:-"*"}
    if [ -z "$namespace" ]; then
        echo "Usage: find-logs <namespace> [file_pattern]"
        return 1
    fi
    grep -r "\[$namespace:" $file 2>/dev/null
}

# Count logs by namespace
count-logs() {
    local namespace=$1
    local file=${2:-"*"}
    if [ -z "$namespace" ]; then
        echo "Usage: count-logs <namespace> [file_pattern]"
        return 1
    fi
    grep -r "\[$namespace:" $file 2>/dev/null | wc -l
}

# Remove logs by namespace (dry run)
remove-logs-dry() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log"}
    
    if [ -z "$namespace" ]; then
        echo "Usage: remove-logs-dry <namespace> [file_pattern]"
        return 1
    fi
    
    echo "🔍 DRY RUN: Would remove logs matching [$namespace:*] from:"
    echo "📁 File pattern: $file_pattern"
    echo "📂 Current directory: $(pwd)"
    echo ""
    
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f | while read file; do
            local matches=$(grep -n "\[$namespace:" "$file" 2>/dev/null)
            if [ ! -z "$matches" ]; then
                echo "📄 File: $file"
                echo "$matches" | head -5
                local total=$(echo "$matches" | wc -l)
                if [ $total -gt 5 ]; then
                    echo "   ... and $((total - 5)) more lines"
                fi
                echo ""
            fi
        done
    done
}

# Remove logs by namespace (actual removal)
remove-logs() {
    local namespace=$1
    local file_pattern=${2:-"*.js *.ts *.py *.log"}
    
    if [ -z "$namespace" ]; then
        echo "Usage: remove-logs <namespace> [file_pattern]"
        echo "Note: Run remove-logs-dry first to preview changes"
        return 1
    fi
    
    echo "⚠️  WARNING: This will remove all logs matching [$namespace:*]"
    echo "📁 File pattern: $file_pattern"
    echo "📂 Directory: $(pwd)"
    read -p "Continue? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        for pattern in $file_pattern; do
            find . -name "$pattern" -type f | while read file; do
                if grep -q "\[$namespace:" "$file" 2>/dev/null; then
                    echo "🧹 Cleaning: $file"
                    # Create backup
                    cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
                    # Remove lines with namespace
                    grep -v "\[$namespace:" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                fi
            done
        done
        echo "✅ Log cleanup completed. Backups created with timestamp suffix."
    else
        echo "❌ Operation cancelled"
    fi
}

# List all namespaces in current directory
list-namespaces() {
    local file_pattern=${1:-"*.js *.ts *.py *.log"}
    echo "🔍 Finding all namespaces in: $file_pattern"
    
    for pattern in $file_pattern; do
        find . -name "$pattern" -type f -exec grep -h "\[.*:" {} \; 2>/dev/null
    done | sed 's/.*\[\([^:]*\):.*/\1/' | sort -u | while read ns; do
        if [ ! -z "$ns" ]; then
            local count=$(count-logs "$ns")
            echo "📊 $ns: $count logs"
        fi
    done
}

# Clean all debug logs (dry run)
clean-debug-dry() {
    echo "🔍 DRY RUN: Would remove all debug logs"
    remove-logs-dry ".*" "*.js *.ts *.py *.log"
}

# Clean all debug logs
clean-debug() {
    echo "🧹 Removing all debug logs"
    remove-logs ".*" "*.js *.ts *.py *.log"
}
```

## 🎮 Usage Examples

### Development Workflow

1. **Add namespace logs during development:**
```javascript
// frontend/src/auth.js
log.auth.debug('Checking user authentication');
log.auth.info('User logged in successfully', user.id);
log.auth.error('Authentication failed', error.message);
```

2. **Find specific logs:**
```bash
find-logs AUTH
find-logs DB "*.py"
```

3. **Preview cleanup:**
```bash
remove-logs-dry AUTH
```

4. **Clean up before commit:**
```bash
remove-logs AUTH
```

5. **List all debug namespaces:**
```bash
list-namespaces
```

### Production Considerations

1. **Environment-based logging:**
```javascript
const DEBUG = process.env.NODE_ENV !== 'production';
const logger = new NamespaceLogger('API', DEBUG);
```

2. **Log levels for production:**
```javascript
const isProduction = process.env.NODE_ENV === 'production';
if (!isProduction) {
    log.debug('This only shows in development');
}
```

## 📝 Best Practices

1. **Consistent Naming:**
   - Use UPPERCASE for namespaces
   - Keep namespaces short (3-8 characters)
   - Use descriptive names

2. **Log Levels:**
   - `DEBUG`: Development debugging
   - `INFO`: General information
   - `WARN`: Warning messages
   - `ERROR`: Error conditions

3. **Before Committing:**
   - Always run `remove-logs-dry` to preview
   - Clean up debug logs with `remove-logs`
   - Keep only necessary INFO/WARN/ERROR logs

4. **Team Conventions:**
   - Agree on common namespaces
   - Document namespace meanings
   - Use consistent formatting

## 🔗 Integration với MyConfig

Các functions này sẽ được tự động thêm vào `.aliases.zsh` khi chạy setup script.

### Quick Setup & Update:
```bash
# Initial setup (includes NNC namespaces)
./auto_setup.sh

# Update aliases with latest NNC features
make update-aliases

# Manual copy (nếu cần)
cp .aliases.zsh ~/
source ~/.zshrc
```

### Customization:
Để thay đổi "NNC" thành initials của bạn, edit trong `.aliases.zsh`:
```bash
# Change PREFIX_NAMESPACES array to your preferred prefix
PREFIX_NAMESPACES=(
    "YourInitials-AUTH"
    "YourInitials-API"
    # etc...
)
```

Hoặc sử dụng make command để update toàn bộ:
```bash
make update-aliases
```
