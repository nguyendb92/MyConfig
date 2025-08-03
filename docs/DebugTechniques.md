# 🐛 Debug Techniques & Debugger Guide for Fullstack Developers

> **Mục tiêu**: Tăng tốc độ debug và hiệu quả troubleshooting cho fullstack development

## 📋 Mục lục
- [Frontend Debugging](#-frontend-debugging)
- [Backend Debugging](#-backend-debugging)
- [Database Debugging](#-database-debugging)
- [API Debugging](#-api-debugging)
- [Docker & DevOps Debugging](#-docker--devops-debugging)
- [VS Code Debug Setup](#-vs-code-debug-setup)
- [Quick Debug Commands](#-quick-debug-commands)
- [Performance Debugging](#-performance-debugging)

---

## 🌐 Frontend Debugging

### 🔍 Browser DevTools Mastery

#### Console Debugging
```javascript
// 1. Advanced Console Methods
console.log('Basic log');
console.warn('Warning message');
console.error('Error message');
console.info('Info message');
console.debug('Debug message');

// 2. Styled Console Output
console.log('%c Custom Styled Message', 'color: #ff6b6b; font-size: 16px; font-weight: bold;');

// 3. Console Table for Objects/Arrays
const users = [
  { name: 'John', age: 30, city: 'NY' },
  { name: 'Jane', age: 25, city: 'LA' }
];
console.table(users);

// 4. Console Group for Organization
console.group('User API Response');
console.log('Status:', response.status);
console.log('Data:', response.data);
console.groupEnd();

// 5. Performance Timing
console.time('API Call');
await fetchData();
console.timeEnd('API Call');

// 6. Stack Trace
console.trace('Function call path');
```

#### 🏷️ NameSpace Debug Logging
```javascript
// ===== NAMESPACE LOGGING TECHNIQUE =====
// Sử dụng namespace để quản lý debug logs dễ dàng

// 1. Define Namespace Constants
const DEBUG_NAMESPACES = {
  API: '[API-DEBUG]',
  UI: '[UI-DEBUG]',
  AUTH: '[AUTH-DEBUG]',
  DB: '[DB-DEBUG]',
  PERFORMANCE: '[PERF-DEBUG]',
  WEBSOCKET: '[WS-DEBUG]',
  VALIDATION: '[VALID-DEBUG]',
  TEMP: '[TEMP-DEBUG]'  // For temporary debugging
};

// 2. Namespace Logging Functions
const log = {
  api: (msg, data) => console.log(`${DEBUG_NAMESPACES.API} ${msg}`, data || ''),
  ui: (msg, data) => console.log(`${DEBUG_NAMESPACES.UI} ${msg}`, data || ''),
  auth: (msg, data) => console.log(`${DEBUG_NAMESPACES.AUTH} ${msg}`, data || ''),
  db: (msg, data) => console.log(`${DEBUG_NAMESPACES.DB} ${msg}`, data || ''),
  perf: (msg, data) => console.log(`${DEBUG_NAMESPACES.PERFORMANCE} ${msg}`, data || ''),
  ws: (msg, data) => console.log(`${DEBUG_NAMESPACES.WEBSOCKET} ${msg}`, data || ''),
  valid: (msg, data) => console.log(`${DEBUG_NAMESPACES.VALIDATION} ${msg}`, data || ''),
  temp: (msg, data) => console.log(`${DEBUG_NAMESPACES.TEMP} ${msg}`, data || '')
};

// 3. Usage Examples
log.api('Fetching user data', { userId: 123 });
log.ui('Button clicked', { buttonId: 'submit-btn' });
log.auth('Login attempt', { username: 'john@doe.com' });
log.db('Query executed', { query: 'SELECT * FROM users' });
log.perf('Function execution time', { duration: '123ms' });
log.temp('Temporary debug info', { state: currentState });

// 4. Conditional Logging based on Environment
const isDev = process.env.NODE_ENV === 'development';
const debugLog = {
  api: isDev ? log.api : () => {},
  ui: isDev ? log.ui : () => {},
  auth: isDev ? log.auth : () => {},
  db: isDev ? log.db : () => {},
  perf: isDev ? log.perf : () => {},
  temp: isDev ? log.temp : () => {}
};

// 5. Advanced Namespace Logging with Color
const colorLog = {
  api: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.API}%c ${msg}`, 
    'color: #61dafb; font-weight: bold;', 'color: inherit;', data || ''),
  ui: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.UI}%c ${msg}`, 
    'color: #ff6b6b; font-weight: bold;', 'color: inherit;', data || ''),
  auth: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.AUTH}%c ${msg}`, 
    'color: #ffd93d; font-weight: bold;', 'color: inherit;', data || ''),
  db: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.DB}%c ${msg}`, 
    'color: #6bcf7f; font-weight: bold;', 'color: inherit;', data || ''),
  perf: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.PERFORMANCE}%c ${msg}`, 
    'color: #ff9ff3; font-weight: bold;', 'color: inherit;', data || ''),
  temp: (msg, data) => console.log(`%c${DEBUG_NAMESPACES.TEMP}%c ${msg}`, 
    'color: #ff9500; font-weight: bold;', 'color: inherit;', data || '')
};

// 6. Namespace-based Log Level Control
class NamespaceLogger {
  constructor() {
    this.enabledNamespaces = new Set(['API', 'UI', 'AUTH', 'DB', 'PERF', 'TEMP']);
  }
  
  enable(namespace) {
    this.enabledNamespaces.add(namespace.toUpperCase());
  }
  
  disable(namespace) {
    this.enabledNamespaces.delete(namespace.toUpperCase());
  }
  
  log(namespace, message, data) {
    if (this.enabledNamespaces.has(namespace.toUpperCase())) {
      const prefix = DEBUG_NAMESPACES[namespace.toUpperCase()];
      console.log(`${prefix} ${message}`, data || '');
    }
  }
}

const nsLogger = new NamespaceLogger();
// Usage:
nsLogger.log('API', 'User data fetched', userData);
nsLogger.log('TEMP', 'Debug checkpoint', { step: 1 });

// Disable certain namespaces
nsLogger.disable('TEMP');  // Will not log TEMP messages anymore
```

#### React/Vue/Angular Debugging

**React DevTools Techniques:**
```javascript
// 1. Component State Inspection
// Install React DevTools browser extension

// 2. Props Drilling Debug
const MyComponent = (props) => {
  console.log('Props received:', props);
  console.log('Props keys:', Object.keys(props));
  
  return <div>...</div>;
};

// 3. useEffect Debugging
useEffect(() => {
  console.log('Effect triggered');
  console.log('Dependencies:', [dep1, dep2]);
  
  return () => {
    console.log('Effect cleanup');
  };
}, [dep1, dep2]);

// 4. Custom Hook Debugging
const useDebugValue = (value, formatter) => {
  React.useDebugValue(value, formatter);
  return value;
};
```

**Vue DevTools Techniques:**
```javascript
// 1. Vue Devtools Event Inspection
// Install Vue DevTools browser extension

// 2. Component Data Debug
export default {
  mounted() {
    console.log('Component data:', this.$data);
    console.log('Component props:', this.$props);
    console.log('Component computed:', this._computedWatchers);
  }
}

// 3. Vuex State Debug
this.$store.subscribe((mutation, state) => {
  console.log('Mutation:', mutation);
  console.log('State after:', state);
});
```

#### Network & API Debugging
```javascript
// 1. Fetch with Error Handling
const debugFetch = async (url, options = {}) => {
  console.group(`🌐 API Call: ${url}`);
  console.log('Request options:', options);
  
  try {
    const response = await fetch(url, options);
    console.log('Response status:', response.status);
    console.log('Response headers:', response.headers);
    
    const data = await response.json();
    console.log('Response data:', data);
    console.groupEnd();
    
    return data;
  } catch (error) {
    console.error('Fetch error:', error);
    console.groupEnd();
    throw error;
  }
};

// 2. Axios Interceptors for Debugging
axios.interceptors.request.use(request => {
  console.log('🚀 Request:', request);
  return request;
});

axios.interceptors.response.use(
  response => {
    console.log('✅ Response:', response);
    return response;
  },
  error => {
    console.error('❌ Response Error:', error);
    return Promise.reject(error);
  }
);
```

### 🔧 Chrome DevTools Advanced Features

#### Performance Profiling
```javascript
// 1. Mark Performance Points
performance.mark('start-render');
// ... your code
performance.mark('end-render');
performance.measure('render-time', 'start-render', 'end-render');

// 2. Memory Usage Monitoring
const memoryInfo = performance.memory;
console.log('Used JS heap:', memoryInfo.usedJSHeapSize);
console.log('Total JS heap:', memoryInfo.totalJSHeapSize);
```

#### Network Tab Mastery
- **Filter by type**: XHR, JS, CSS, Img, Media, Font, Doc, WS, Manifest, Other
- **Throttling**: Simulate slow connections
- **Offline mode**: Test offline functionality
- **Cache disable**: Force fresh requests

---

## ⚙️ Backend Debugging

### 🐍 Python/Django Debugging

#### 🏷️ Python NameSpace Debug Logging
```python
# ===== PYTHON NAMESPACE LOGGING TECHNIQUE =====

import logging
import sys
from datetime import datetime

# 1. Define Debug Namespaces
class DebugNamespaces:
    API = '[API-DEBUG]'
    DATABASE = '[DB-DEBUG]'
    AUTH = '[AUTH-DEBUG]'
    VIEWS = '[VIEW-DEBUG]'
    MODELS = '[MODEL-DEBUG]'
    FORMS = '[FORM-DEBUG]'
    CELERY = '[CELERY-DEBUG]'
    PERFORMANCE = '[PERF-DEBUG]'
    TEMP = '[TEMP-DEBUG]'

# 2. Namespace Logger Class
class NamespaceLogger:
    def __init__(self, enabled_namespaces=None):
        self.enabled_namespaces = enabled_namespaces or {
            'API', 'DATABASE', 'AUTH', 'VIEWS', 'MODELS', 'FORMS', 'CELERY', 'PERF', 'TEMP'
        }
        
        # Setup colored logging
        logging.basicConfig(
            level=logging.DEBUG,
            format='%(asctime)s - %(message)s',
            handlers=[logging.StreamHandler(sys.stdout)]
        )
        self.logger = logging.getLogger(__name__)
    
    def enable(self, namespace):
        self.enabled_namespaces.add(namespace.upper())
    
    def disable(self, namespace):
        self.enabled_namespaces.discard(namespace.upper())
    
    def _log(self, namespace, message, data=None):
        if namespace.upper() in self.enabled_namespaces:
            ns_prefix = getattr(DebugNamespaces, namespace.upper(), f'[{namespace}-DEBUG]')
            log_msg = f'{ns_prefix} {message}'
            if data:
                log_msg += f' | Data: {data}'
            self.logger.debug(log_msg)
    
    def api(self, message, data=None):
        self._log('API', message, data)
    
    def database(self, message, data=None):
        self._log('DATABASE', message, data)
    
    def auth(self, message, data=None):
        self._log('AUTH', message, data)
    
    def views(self, message, data=None):
        self._log('VIEWS', message, data)
    
    def models(self, message, data=None):
        self._log('MODELS', message, data)
    
    def forms(self, message, data=None):
        self._log('FORMS', message, data)
    
    def celery(self, message, data=None):
        self._log('CELERY', message, data)
    
    def perf(self, message, data=None):
        self._log('PERFORMANCE', message, data)
    
    def temp(self, message, data=None):
        self._log('TEMP', message, data)

# 3. Global Logger Instance
debug_log = NamespaceLogger()

# 4. Usage Examples
def user_login_view(request):
    debug_log.auth('Login attempt started', {'username': request.POST.get('username')})
    debug_log.views('Processing login view', {'method': request.method})
    
    # ... login logic
    
    debug_log.database('User query executed', {'query': 'SELECT * FROM auth_user WHERE username = ?'})
    debug_log.auth('Login successful', {'user_id': user.id})

# 5. Decorator for Function-level Namespace Logging
def namespace_debug(namespace):
    def decorator(func):
        def wrapper(*args, **kwargs):
            debug_log._log(namespace, f'Function {func.__name__} called', {'args': len(args), 'kwargs': list(kwargs.keys())})
            start_time = datetime.now()
            
            try:
                result = func(*args, **kwargs)
                execution_time = (datetime.now() - start_time).total_seconds()
                debug_log.perf(f'Function {func.__name__} completed', {'execution_time': f'{execution_time:.4f}s'})
                return result
            except Exception as e:
                debug_log._log(namespace, f'Function {func.__name__} failed', {'error': str(e)})
                raise
        return wrapper
    return decorator

# 6. Usage with Decorator
@namespace_debug('API')
def fetch_user_data(user_id):
    debug_log.database('Fetching user data', {'user_id': user_id})
    # ... database query
    return user_data
```

#### PDB (Python Debugger)
```python
# 1. Basic PDB Usage
import pdb

def my_function():
    x = 10
    pdb.set_trace()  # Breakpoint
    y = x * 2
    return y

# 2. Post-mortem Debugging
try:
    risky_function()
except Exception:
    import pdb
    pdb.post_mortem()

# 3. IPython Enhanced Debugger
import ipdb
ipdb.set_trace()  # Better interface than pdb
```

#### Django Debug Toolbar
```python
# settings.py
if DEBUG:
    INSTALLED_APPS += ['debug_toolbar']
    MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
    
    DEBUG_TOOLBAR_CONFIG = {
        'SHOW_TOOLBAR_CALLBACK': lambda request: True,
    }
    
    import socket
    hostname, _, ips = socket.gethostbyname_ex(socket.gethostname())
    INTERNAL_IPS = [ip[: ip.rfind(".")] + ".1" for ip in ips] + ["127.0.0.1", "10.0.2.2"]
```

#### Advanced Python Debugging
```python
# 1. Logging Setup
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('debug.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

def debug_function():
    logger.debug('Debug message')
    logger.info('Info message')
    logger.warning('Warning message')
    logger.error('Error message')

# 2. Function Execution Time Decorator
import time
from functools import wraps

def debug_time(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        logger.debug(f'{func.__name__} took {end_time - start_time:.4f} seconds')
        return result
    return wrapper

@debug_time
def slow_function():
    time.sleep(1)
    return "Done"

# 3. Memory Usage Tracking
import tracemalloc

def debug_memory():
    tracemalloc.start()
    
    # Your code here
    current, peak = tracemalloc.get_traced_memory()
    
    print(f"Current memory usage: {current / 1024 / 1024:.1f} MB")
    print(f"Peak memory usage: {peak / 1024 / 1024:.1f} MB")
    
    tracemalloc.stop()
```

### 🟢 Node.js/Express Debugging

#### Node.js Built-in Debugger
```javascript
// 1. Node.js Inspector
// Run: node --inspect-brk app.js
// Open: chrome://inspect

// 2. Debug Statements
const debug = require('debug')('app:server');

debug('Server starting...');
debug('Database connected');
debug('Routes loaded');

// 3. Console Debugging with Context
const debugLog = (message, data = null) => {
  const timestamp = new Date().toISOString();
  const stack = new Error().stack.split('\n')[2].trim();
  
  console.log(`[${timestamp}] ${message}`);
  console.log(`[STACK] ${stack}`);
  if (data) console.log('[DATA]', data);
};

// 4. Express Request Debugging
const requestDebugger = (req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  console.log('Query:', req.query);
  console.log('Params:', req.params);
  next();
};

app.use(requestDebugger);
```

#### Performance Monitoring
```javascript
// 1. Express Response Time
const responseTime = require('response-time');

app.use(responseTime((req, res, time) => {
  console.log(`${req.method} ${req.url} - ${time.toFixed(2)}ms`);
}));

// 2. Memory Usage Monitoring
const memoryUsage = () => {
  const usage = process.memoryUsage();
  console.log({
    rss: `${Math.round(usage.rss / 1024 / 1024 * 100) / 100} MB`,
    heapTotal: `${Math.round(usage.heapTotal / 1024 / 1024 * 100) / 100} MB`,
    heapUsed: `${Math.round(usage.heapUsed / 1024 / 1024 * 100) / 100} MB`,
    external: `${Math.round(usage.external / 1024 / 1024 * 100) / 100} MB`
  });
};

// Check memory every 30 seconds
setInterval(memoryUsage, 30000);
```

---

## 🗄️ Database Debugging

### 🐬 MySQL Debugging

#### Query Performance Analysis
```sql
-- 1. Enable Query Logging
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log_file = '/var/log/mysql/general.log';

-- 2. Slow Query Analysis
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL slow_query_log_file = '/var/log/mysql/slow.log';
SET GLOBAL long_query_time = 1; -- Log queries taking > 1 second

-- 3. Explain Query Performance
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';
EXPLAIN FORMAT=JSON SELECT * FROM users u JOIN orders o ON u.id = o.user_id;

-- 4. Show Query Execution Plan
SHOW STATUS LIKE 'Handler%';
SHOW STATUS LIKE 'Created_tmp%';

-- 5. Index Analysis
SHOW INDEX FROM users;
SHOW TABLE STATUS LIKE 'users';

-- 6. Lock Analysis
SHOW ENGINE INNODB STATUS;
SHOW PROCESSLIST;
```

#### MySQL Performance Debugging
```sql
-- 1. Connection Analysis
SHOW STATUS LIKE 'Threads%';
SHOW STATUS LIKE 'Max_used_connections';

-- 2. Buffer Pool Analysis
SHOW STATUS LIKE 'Innodb_buffer_pool%';

-- 3. Query Cache Analysis
SHOW STATUS LIKE 'Qcache%';

-- 4. Performance Schema Queries
SELECT * FROM performance_schema.events_statements_summary_by_digest 
ORDER BY SUM_TIMER_WAIT DESC LIMIT 10;
```

### 🐘 PostgreSQL Debugging

#### Query Analysis
```sql
-- 1. Enable Query Logging
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_min_duration_statement = 1000; -- Log slow queries

-- 2. Query Execution Plan
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user@example.com';
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users u JOIN orders o ON u.id = o.user_id;

-- 3. Index Usage Analysis
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan;

-- 4. Table Statistics
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan, idx_tup_fetch
FROM pg_stat_user_tables;

-- 5. Lock Analysis
SELECT pid, state, query, query_start, state_change
FROM pg_stat_activity
WHERE state != 'idle';
```

### 🍃 MongoDB Debugging

#### Query Profiling
```javascript
// 1. Enable Profiler
db.setProfilingLevel(2); // Profile all operations
db.setProfilingLevel(1, { slowms: 100 }); // Profile slow operations

// 2. Query Explanation
db.users.find({ email: "user@example.com" }).explain("executionStats");

// 3. Index Analysis
db.users.getIndexes();
db.users.totalIndexSize();

// 4. Performance Statistics
db.stats();
db.users.stats();

// 5. Current Operations
db.currentOp();

// 6. Profile Collection Analysis
db.system.profile.find().limit(5).sort({ ts: -1 }).pretty();
```

---

## 🔌 API Debugging

### 🚀 Quick API Testing Commands

#### cURL Commands
```bash
# 1. GET Request with Headers
curl -H "Authorization: Bearer TOKEN" \
     -H "Content-Type: application/json" \
     https://api.example.com/users

# 2. POST Request with JSON Data
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name":"John","email":"john@example.com"}' \
     https://api.example.com/users

# 3. PUT Request with File Upload
curl -X PUT \
     -F "file=@./image.jpg" \
     -F "title=My Image" \
     https://api.example.com/upload

# 4. Debug with Verbose Output
curl -v https://api.example.com/users

# 5. Save Response to File
curl -o response.json https://api.example.com/users

# 6. Follow Redirects
curl -L https://api.example.com/redirect

# 7. Set Timeout
curl --max-time 30 https://api.example.com/slow-endpoint

# 8. Custom User Agent
curl -A "MyApp/1.0" https://api.example.com/users
```

#### HTTPie Commands (Modern Alternative)
```bash
# Install: pip install httpie

# 1. GET Request
http GET https://api.example.com/users Authorization:"Bearer TOKEN"

# 2. POST JSON Data
http POST https://api.example.com/users name=John email=john@example.com

# 3. PUT with File Upload
http PUT https://api.example.com/upload file@./image.jpg title="My Image"

# 4. Query Parameters
http GET https://api.example.com/users page==1 limit==10

# 5. Download File
http --download https://api.example.com/file.pdf
```

### 🧪 Postman Advanced Debugging

#### Pre-request Scripts
```javascript
// 1. Generate Random Data
pm.globals.set("randomEmail", `user${Math.random()}@example.com`);
pm.globals.set("timestamp", Date.now());

// 2. Calculate Authentication Token
const crypto = require('crypto-js');
const token = crypto.HmacSHA256(pm.globals.get("timestamp"), "secret_key");
pm.globals.set("authToken", token.toString());

// 3. Environment Variables
pm.environment.set("baseUrl", "https://api.example.com");
```

#### Test Scripts
```javascript
// 1. Response Time Testing
pm.test("Response time is less than 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

// 2. Status Code Testing
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// 3. JSON Schema Validation
const schema = {
    type: "object",
    properties: {
        id: { type: "number" },
        name: { type: "string" },
        email: { type: "string" }
    },
    required: ["id", "name", "email"]
};

pm.test("Response matches schema", function () {
    pm.response.to.have.jsonSchema(schema);
});

// 4. Extract Data for Next Request
const responseJson = pm.response.json();
pm.globals.set("userId", responseJson.id);
```

---

## 🐳 Docker & DevOps Debugging

### 🐋 Docker Debugging Commands

#### Container Debugging
```bash
# 1. List All Containers (including stopped)
docker ps -a

# 2. Inspect Container Details
docker inspect container_name

# 3. View Container Logs
docker logs container_name
docker logs -f container_name  # Follow logs
docker logs --tail 50 container_name  # Last 50 lines

# 4. Execute Commands in Running Container
docker exec -it container_name /bin/bash
docker exec -it container_name sh

# 5. Container Resource Usage
docker stats container_name

# 6. Copy Files to/from Container
docker cp file.txt container_name:/path/to/destination
docker cp container_name:/path/to/file.txt ./local/path

# 7. Container Process List
docker exec container_name ps aux

# 8. Network Debugging
docker network ls
docker network inspect bridge
docker port container_name
```

#### Docker Compose Debugging
```bash
# 1. View Services Status
docker-compose ps

# 2. View Service Logs
docker-compose logs service_name
docker-compose logs -f  # Follow all logs

# 3. Execute Commands in Service
docker-compose exec service_name /bin/bash

# 4. Rebuild Services
docker-compose up --build

# 5. Validate Compose File
docker-compose config

# 6. Scale Services
docker-compose up --scale web=3

# 7. Service Dependencies Check
docker-compose up --no-deps service_name
```

#### Image Debugging
```bash
# 1. Image History
docker history image_name

# 2. Image Layers Analysis
docker inspect image_name

# 3. Dive Tool (Advanced Image Analysis)
# Install: wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
dive image_name

# 4. Remove Unused Images
docker image prune
docker system prune -a
```

---

## 🔧 VS Code Debug Setup

### 🐍 Python Debugging Configuration

#### launch.json for Python/Django
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Django",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/manage.py",
            "args": ["runserver", "0.0.0.0:8000"],
            "django": true,
            "justMyCode": false,
            "console": "integratedTerminal"
        },
        {
            "name": "Python: FastAPI",
            "type": "python",
            "request": "launch",
            "module": "uvicorn",
            "args": ["main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"],
            "console": "integratedTerminal"
        },
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal"
        },
        {
            "name": "Python: Tests",
            "type": "python",
            "request": "launch",
            "module": "pytest",
            "args": ["${workspaceFolder}/tests", "-v"],
            "console": "integratedTerminal"
        }
    ]
}
```

### 🟢 Node.js Debugging Configuration

#### launch.json for Node.js/Express
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Node.js: Express Server",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/app.js",
            "env": {
                "NODE_ENV": "development",
                "DEBUG": "*"
            },
            "console": "integratedTerminal",
            "restart": true,
            "runtimeArgs": ["--nolazy"]
        },
        {
            "name": "Node.js: Nodemon",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/app.js",
            "runtimeExecutable": "nodemon",
            "restart": true,
            "env": {
                "NODE_ENV": "development"
            }
        },
        {
            "name": "Node.js: Jest Tests",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/jest",
            "args": ["--runInBand"],
            "console": "integratedTerminal"
        },
        {
            "name": "Node.js: Attach to Process",
            "type": "node",
            "request": "attach",
            "port": 9229,
            "restart": true,
            "localRoot": "${workspaceFolder}",
            "remoteRoot": "/app"
        }
    ]
}
```

### 🌐 Frontend Debugging Configuration

#### launch.json for React/Vue
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "React: Chrome Debug",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:3000",
            "webRoot": "${workspaceFolder}/src",
            "sourceMapPathOverrides": {
                "webpack:///src/*": "${webRoot}/*"
            }
        },
        {
            "name": "Vue: Chrome Debug",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:8080",
            "webRoot": "${workspaceFolder}/src",
            "breakOnLoad": true,
            "sourceMapPathOverrides": {
                "webpack:///src/*": "${webRoot}/*"
            }
        },
        {
            "name": "Angular: Chrome Debug",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:4200",
            "webRoot": "${workspaceFolder}",
            "sourceMapPathOverrides": {
                "webpack:/*": "${workspaceFolder}/*"
            }
        }
    ]
}
```

### 🐳 Docker Debugging Configuration

#### launch.json for Docker
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Docker: Python Remote",
            "type": "python",
            "request": "attach",
            "port": 5678,
            "host": "localhost",
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "/app"
                }
            ]
        },
        {
            "name": "Docker: Node.js Remote",
            "type": "node",
            "request": "attach",
            "port": 9229,
            "address": "localhost",
            "localRoot": "${workspaceFolder}",
            "remoteRoot": "/app",
            "protocol": "inspector"
        }
    ]
}
```

---

## ⚡ Quick Debug Commands

### 🔧 Useful Debug Aliases (Add to ~/.aliases.zsh)

```bash
# System Debug
alias debug-ports='netstat -tuln'
alias debug-processes='ps aux | grep -v grep'
alias debug-memory='free -h && df -h'
alias debug-cpu='top -n 1 | head -20'

# Network Debug
alias debug-dns='nslookup'
alias debug-ping='ping -c 4'
alias debug-trace='traceroute'
alias debug-curl='curl -v'

# Docker Debug
alias debug-docker='docker ps -a && docker images'
alias debug-compose='docker-compose ps && docker-compose logs --tail=20'
alias docker-cleanup='docker system prune -a'

# Database Debug
alias debug-mysql='mysql -u root -p -e "SHOW PROCESSLIST;"'
alias debug-postgres='psql -U postgres -c "SELECT * FROM pg_stat_activity;"'

# Application Debug
alias debug-node='node --inspect-brk'
alias debug-python='python -m pdb'
alias debug-django='python manage.py shell'

# Log Analysis
alias debug-nginx='tail -f /var/log/nginx/error.log'
alias debug-apache='tail -f /var/log/apache2/error.log'
alias debug-syslog='tail -f /var/log/syslog'

# Performance Debug
alias debug-disk='iotop'
alias debug-network='iftop'
alias debug-files='lsof'
```

### 🚀 Quick Debug Scripts

#### System Health Check Script
```bash
#!/bin/bash
# save as: debug_system.sh

echo "🔍 System Debug Information"
echo "=========================="

echo "\n📊 System Overview:"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime)"
echo "Current User: $(whoami)"
echo "Date: $(date)"

echo "\n💾 Memory Usage:"
free -h

echo "\n💽 Disk Usage:"
df -h

echo "\n🔧 CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2 $4}'

echo "\n🌐 Network Interfaces:"
ip addr show | grep -E "^[0-9]|inet "

echo "\n🚀 Running Services:"
systemctl list-units --type=service --state=running | head -10

echo "\n📝 Recent System Logs:"
journalctl -p 3 -xn 5 --no-pager
```

#### Application Debug Script
```bash
#!/bin/bash
# save as: debug_app.sh

APP_NAME=${1:-"myapp"}
LOG_LINES=${2:-50}

echo "🐛 Application Debug: $APP_NAME"
echo "================================"

echo "\n🐳 Docker Status:"
docker-compose ps

echo "\n📜 Application Logs (last $LOG_LINES lines):"
docker-compose logs --tail=$LOG_LINES $APP_NAME

echo "\n🔍 Container Details:"
docker inspect $(docker-compose ps -q $APP_NAME) | jq '.[0].State'

echo "\n📊 Resource Usage:"
docker stats --no-stream $(docker-compose ps -q $APP_NAME)

echo "\n🌐 Network Connectivity:"
docker exec $(docker-compose ps -q $APP_NAME) ping -c 2 google.com

echo "\n📁 Container File System:"
docker exec $(docker-compose ps -q $APP_NAME) df -h
```

---

## 📈 Performance Debugging

### 🔍 Frontend Performance

#### JavaScript Performance
```javascript
// 1. Performance Measurement
const performanceMonitor = {
  start: (label) => {
    console.time(label);
    performance.mark(`${label}-start`);
  },
  
  end: (label) => {
    console.timeEnd(label);
    performance.mark(`${label}-end`);
    performance.measure(label, `${label}-start`, `${label}-end`);
  },
  
  getMetrics: () => {
    return performance.getEntriesByType('measure');
  }
};

// Usage
performanceMonitor.start('data-fetch');
await fetchData();
performanceMonitor.end('data-fetch');

// 2. Memory Leak Detection
const memoryMonitor = {
  start: () => {
    if (performance.memory) {
      console.log('Initial memory:', performance.memory);
    }
  },
  
  check: (label) => {
    if (performance.memory) {
      console.log(`${label} memory:`, performance.memory);
    }
  }
};

// 3. FPS Monitoring
let fps = 0;
let lastTime = performance.now();

function countFPS() {
  const currentTime = performance.now();
  fps = 1000 / (currentTime - lastTime);
  lastTime = currentTime;
  
  if (fps < 30) {
    console.warn(`Low FPS detected: ${fps.toFixed(2)}`);
  }
  
  requestAnimationFrame(countFPS);
}

countFPS();
```

#### React Performance Debugging
```javascript
// 1. Profiler Component
import { Profiler } from 'react';

function onRenderCallback(id, phase, actualDuration, baseDuration, startTime, commitTime) {
  console.log('Profiler:', {
    id,
    phase,
    actualDuration,
    baseDuration,
    startTime,
    commitTime
  });
}

function App() {
  return (
    <Profiler id="App" onRender={onRenderCallback}>
      <MyComponent />
    </Profiler>
  );
}

// 2. useMemo and useCallback Debugging
const expensiveValue = useMemo(() => {
  console.log('Computing expensive value');
  return computeExpensiveValue();
}, [dependency]);

const memoizedCallback = useCallback(() => {
  console.log('Callback created');
  return doSomething();
}, [dependency]);

// 3. Component Re-render Tracking
function useWhyDidYouUpdate(name, props) {
  const previous = useRef();
  
  useEffect(() => {
    if (previous.current) {
      const allKeys = Object.keys({...previous.current, ...props});
      const changedProps = {};
      
      allKeys.forEach(key => {
        if (previous.current[key] !== props[key]) {
          changedProps[key] = {
            from: previous.current[key],
            to: props[key]
          };
        }
      });
      
      if (Object.keys(changedProps).length) {
        console.log('[why-did-you-update]', name, changedProps);
      }
    }
    
    previous.current = props;
  });
}
```

### ⚙️ Backend Performance

#### Python/Django Performance
```python
# 1. Django Debug Toolbar Settings
# In settings.py for detailed SQL analysis

# 2. Query Optimization
from django.db import connection
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    def handle(self, *args, **options):
        # Reset query count
        connection.queries_log.clear()
        
        # Your code here
        users = User.objects.select_related('profile').all()
        
        # Check query count
        print(f"Number of queries: {len(connection.queries)}")
        for query in connection.queries:
            print(f"Query: {query['sql']}")
            print(f"Time: {query['time']}")

# 3. Custom Performance Decorator
import time
import functools

def performance_monitor(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        
        # Memory before
        import tracemalloc
        tracemalloc.start()
        
        result = func(*args, **kwargs)
        
        # Execution time
        execution_time = time.time() - start_time
        
        # Memory after
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()
        
        print(f"Function: {func.__name__}")
        print(f"Execution time: {execution_time:.4f} seconds")
        print(f"Memory usage: {current / 1024 / 1024:.1f} MB")
        print(f"Peak memory: {peak / 1024 / 1024:.1f} MB")
        
        return result
    
    return wrapper
```

#### Node.js Performance
```javascript
// 1. Process Monitoring
const processMonitor = {
  start: () => {
    console.log('Process ID:', process.pid);
    console.log('Node version:', process.version);
    console.log('Platform:', process.platform);
  },
  
  memory: () => {
    const usage = process.memoryUsage();
    console.log({
      rss: `${Math.round(usage.rss / 1024 / 1024 * 100) / 100} MB`,
      heapTotal: `${Math.round(usage.heapTotal / 1024 / 1024 * 100) / 100} MB`,
      heapUsed: `${Math.round(usage.heapUsed / 1024 / 1024 * 100) / 100} MB`,
      external: `${Math.round(usage.external / 1024 / 1024 * 100) / 100} MB`
    });
  },
  
  cpu: () => {
    const usage = process.cpuUsage();
    console.log({
      user: `${usage.user / 1000}ms`,
      system: `${usage.system / 1000}ms`
    });
  }
};

// 2. Event Loop Monitoring
const eventLoopMonitor = () => {
  const start = process.hrtime.bigint();
  
  setImmediate(() => {
    const lag = Number(process.hrtime.bigint() - start) / 1e6;
    
    if (lag > 10) {
      console.warn(`Event loop lag: ${lag.toFixed(2)}ms`);
    }
  });
};

setInterval(eventLoopMonitor, 1000);

// 3. Database Query Performance
const queryPerformance = async (query, params) => {
  const start = process.hrtime.bigint();
  
  try {
    const result = await db.query(query, params);
    const duration = Number(process.hrtime.bigint() - start) / 1e6;
    
    console.log(`Query executed in ${duration.toFixed(2)}ms`);
    console.log(`Rows affected: ${result.rowCount || result.length}`);
    
    if (duration > 100) {
      console.warn('Slow query detected:', query);
    }
    
    return result;
  } catch (error) {
    console.error('Query error:', error);
    throw error;
  }
};
```

---

## 🎯 Debug Workflow Best Practices

### 📋 Systematic Debugging Approach

1. **Reproduce the Issue**
   - Create minimal test case
   - Document steps to reproduce
   - Identify consistent patterns

2. **Gather Information**
   - Check logs (application, system, database)
   - Monitor resource usage (CPU, memory, network)
   - Review recent changes

3. **Isolate the Problem**
   - Binary search approach
   - Comment out code sections
   - Use breakpoints strategically

4. **Test Hypotheses**
   - Make one change at a time
   - Test each change thoroughly
   - Document what works/doesn't work

5. **Verify the Fix**
   - Test in different environments
   - Check edge cases
   - Monitor for regressions

### 🔧 Environment Setup Tips

```bash
# 1. Development Environment Variables
export DEBUG=true
export LOG_LEVEL=debug
export NODE_ENV=development
export DJANGO_DEBUG=True

# 2. Quick Environment Switcher
debug_mode() {
    export DEBUG=true
    export LOG_LEVEL=debug
    echo "Debug mode enabled"
}

production_mode() {
    export DEBUG=false
    export LOG_LEVEL=error
    echo "Production mode enabled"
}

# 3. Quick Service Restart
restart_dev() {
    docker-compose down
    docker-compose up -d
    docker-compose logs -f
}
```

---

## 🎉 Kết luận

Debug hiệu quả là kỹ năng quan trọng nhất của fullstack developer. Với toolkit này, bạn có thể:

- **Tiết kiệm thời gian**: Debug nhanh chóng và chính xác
- **Hiểu sâu hơn**: Biết cách hệ thống hoạt động
- **Tự tin hơn**: Có công cụ cho mọi tình huống debug
- **Chuyên nghiệp hơn**: Áp dụng best practices trong debug

**💡 Tip cuối**: Lưu các debug command thường dùng vào aliases, tạo debug scripts cho từng project, và luôn document lại các issue đã solve để reference sau này!

---

## 🧹 Debug Log Cleanup & Management

### 🏷️ NameSpace-based Log Cleanup Scripts

#### JavaScript/Node.js Log Cleanup
```bash
#!/bin/bash
# cleanup-debug-logs.sh - Remove namespace debug logs from JavaScript files

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Available namespaces
NAMESPACES=("API-DEBUG" "UI-DEBUG" "AUTH-DEBUG" "DB-DEBUG" "PERF-DEBUG" "WS-DEBUG" "VALID-DEBUG" "TEMP-DEBUG")

# Function to show what will be removed (dry run)
dry_run_cleanup() {
    local namespace=$1
    local directory=${2:-.}
    
    echo -e "${BLUE}🔍 DRY RUN - Searching for ${namespace} logs in: ${directory}${NC}"
    echo ""
    
    # Find all JavaScript/TypeScript files
    local files=$(find "$directory" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    
    local total_matches=0
    
    for file in $files; do
        # Count matches for this namespace
        local matches=$(grep -n "\[${namespace}\]" "$file" 2>/dev/null | wc -l)
        
        if [ "$matches" -gt 0 ]; then
            echo -e "${YELLOW}📄 File: ${file}${NC}"
            echo -e "   ${GREEN}Found ${matches} log(s) with namespace [${namespace}]${NC}"
            
            # Show the actual lines that would be removed
            grep -n "\[${namespace}\]" "$file" 2>/dev/null | while read -r line; do
                echo -e "   ${RED}Line:${NC} $line"
            done
            echo ""
            
            total_matches=$((total_matches + matches))
        fi
    done
    
    echo -e "${BLUE}📊 Total: ${total_matches} log statements found with namespace [${namespace}]${NC}"
    echo ""
}

# Function to actually remove the logs
cleanup_namespace_logs() {
    local namespace=$1
    local directory=${2:-.}
    
    echo -e "${BLUE}🧹 Cleaning up ${namespace} logs in: ${directory}${NC}"
    
    # Find all JavaScript/TypeScript files
    local files=$(find "$directory" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*")
    
    local total_removed=0
    
    for file in $files; do
        # Create backup
        cp "$file" "${file}.backup"
        
        # Remove lines containing the namespace
        local removed=$(grep -c "\[${namespace}\]" "$file" 2>/dev/null || echo "0")
        
        if [ "$removed" -gt 0 ]; then
            # Remove the lines and clean up
            sed -i "/\[${namespace}\]/d" "$file"
            
            # Remove empty console.log() calls
            sed -i '/^[[:space:]]*console\.log()[[:space:]]*;*[[:space:]]*$/d' "$file"
            
            # Remove empty log calls
            sed -i '/^[[:space:]]*log\.[a-zA-Z]*()[[:space:]]*;*[[:space:]]*$/d' "$file"
            
            echo -e "${GREEN}✅ Cleaned ${removed} log(s) from: ${file}${NC}"
            total_removed=$((total_removed + removed))
        else
            # Remove backup if no changes
            rm "${file}.backup"
        fi
    done
    
    echo -e "${GREEN}🎉 Cleanup completed! Removed ${total_removed} log statements.${NC}"
    echo -e "${YELLOW}💡 Backup files created with .backup extension${NC}"
}

# Main script usage
# Usage: ./cleanup-debug-logs.sh dry-run TEMP-DEBUG
# Usage: ./cleanup-debug-logs.sh cleanup TEMP-DEBUG src/
```

#### Python Log Cleanup Script
```bash
#!/bin/bash
# cleanup-python-debug.sh - Remove namespace debug logs from Python files

# Function to remove Python debug logs
cleanup_python_logs() {
    local namespace=$1
    local directory=${2:-.}
    
    echo -e "${BLUE}🧹 Cleaning up ${namespace} logs in: ${directory}${NC}"
    
    # Find all Python files
    local files=$(find "$directory" -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" ! -path "*/migrations/*")
    
    local total_removed=0
    
    for file in $files; do
        # Create backup
        cp "$file" "${file}.backup"
        
        # Remove lines containing the namespace
        local removed=$(grep -c "\[${namespace}\]" "$file" 2>/dev/null || echo "0")
        
        if [ "$removed" -gt 0 ]; then
            # Remove the lines and clean up
            sed -i "/\[${namespace}\]/d" "$file"
            
            # Remove empty debug_log calls
            sed -i '/^[[:space:]]*debug_log\.[a-zA-Z]*()[[:space:]]*$/d' "$file"
            
            echo -e "${GREEN}✅ Cleaned ${removed} log(s) from: ${file}${NC}"
            total_removed=$((total_removed + removed))
        else
            rm "${file}.backup"
        fi
    done
    
    echo -e "${GREEN}🎉 Cleanup completed! Removed ${total_removed} log statements.${NC}"
}
```

### 🔧 Useful Aliases for Debug Management

Add these to your `.aliases.zsh`:

```bash
# Debug log cleanup aliases
alias debug-dry='./cleanup-debug-logs.sh dry-run'
alias debug-clean='./cleanup-debug-logs.sh cleanup'
alias debug-restore='./cleanup-debug-logs.sh restore'

# Quick namespace cleanup functions
clean-temp-logs() {
    echo "🧹 Cleaning TEMP-DEBUG logs..."
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/venv/*" -exec grep -l "\[TEMP-DEBUG\]" {} \;
    read -p "Proceed with cleanup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/venv/*" -exec sed -i.backup '/\[TEMP-DEBUG\]/d' {} \;
        echo "✅ TEMP-DEBUG logs removed!"
    fi
}

# Find all namespace logs
find-debug-logs() {
    local namespace=${1:-"DEBUG"}
    echo "🔍 Searching for all [$namespace] logs..."
    
    # JavaScript/TypeScript files
    find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec grep -Hn "\[${namespace}\]" {} \;
    
    # Python files
    find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec grep -Hn "\[${namespace}\]" {} \;
}

# Count debug logs by namespace
count-debug-logs() {
    echo "📊 Debug log statistics:"
    echo ""
    
    for ns in "API-DEBUG" "UI-DEBUG" "AUTH-DEBUG" "DB-DEBUG" "TEMP-DEBUG"; do
        local js_count=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/dist/*" -exec grep -c "\[${ns}\]" {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
        local py_count=$(find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/__pycache__/*" -exec grep -c "\[${ns}\]" {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
        
        echo "[$ns]: JS/TS: $js_count, Python: $py_count"
    done
}

# Remove all backup files
remove-debug-backups() {
    echo "🗑️  Removing debug cleanup backup files..."
    find . -name "*.backup" -type f -exec rm {} \;
    echo "✅ All backup files removed!"
}
```

### 📝 Quick Debug Commands

```bash
# Create these as executable scripts in ~/Scripts/

# 1. Quick dry-run for TEMP namespace
echo '#!/bin/bash
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/venv/*" -exec grep -Hn "\[TEMP-DEBUG\]" {} \;' > ~/Scripts/find-temp-debug.sh
chmod +x ~/Scripts/find-temp-debug.sh

# 2. Clean all temporary debug logs
echo '#!/bin/bash
echo "🔍 Finding TEMP-DEBUG logs..."
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/venv/*" -exec grep -l "\[TEMP-DEBUG\]" {} \; > /tmp/temp-debug-files.txt

if [ -s /tmp/temp-debug-files.txt ]; then
    echo "📄 Files containing TEMP-DEBUG:"
    cat /tmp/temp-debug-files.txt
    echo ""
    read -p "Remove all TEMP-DEBUG logs? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while read -r file; do
            cp "$file" "${file}.backup"
            sed -i "/\[TEMP-DEBUG\]/d" "$file"
            echo "✅ Cleaned: $file"
        done < /tmp/temp-debug-files.txt
        echo "🎉 All TEMP-DEBUG logs removed!"
    fi
else
    echo "✅ No TEMP-DEBUG logs found!"
fi' > ~/Scripts/clean-temp-debug.sh
chmod +x ~/Scripts/clean-temp-debug.sh
```

---

*🔧 Happy Debugging! Remember: Every bug is an opportunity to understand your system better.*
