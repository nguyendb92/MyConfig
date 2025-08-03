# Debug Techniques for Fullstack Developers

## 🎯 Tổng quan

Bộ kỹ thuật debug toàn diện cho fullstack developers, bao gồm frontend, backend, database, và DevOps debugging với các công cụ và best practices hiệu quả.

## 📋 Mục lục

1. [Frontend Debugging](#-frontend-debugging)
2. [Backend Debugging](#-backend-debugging)
3. [Database Debugging](#-database-debugging)
4. [API Debugging](#-api-debugging)
5. [Performance Debugging](#-performance-debugging)
6. [Production Debugging](#-production-debugging)
7. [Namespace Logging System](#-namespace-logging-system)
8. [Tools & Extensions](#-tools--extensions)

## 🎨 Frontend Debugging

### Browser DevTools

#### Console Debugging
```javascript
// Namespace logging system
const log = {
    ui: {
        debug: (msg, ...args) => console.log(`[UI:DEBUG]`, msg, ...args),
        info: (msg, ...args) => console.log(`[UI:INFO]`, msg, ...args),
        warn: (msg, ...args) => console.warn(`[UI:WARN]`, msg, ...args),
        error: (msg, ...args) => console.error(`[UI:ERROR]`, msg, ...args)
    },
    api: {
        debug: (msg, ...args) => console.log(`[API:DEBUG]`, msg, ...args),
        info: (msg, ...args) => console.log(`[API:INFO]`, msg, ...args),
        error: (msg, ...args) => console.error(`[API:ERROR]`, msg, ...args)
    },
    state: {
        debug: (msg, ...args) => console.log(`[STATE:DEBUG]`, msg, ...args),
        change: (msg, ...args) => console.log(`[STATE:CHANGE]`, msg, ...args)
    }
};

// Usage examples
log.ui.debug('Component rendered', { props, state });
log.api.error('Request failed', error);
log.state.change('User logged in', user);
```

#### Advanced Console Techniques
```javascript
// Grouping logs
console.group('[AUTH:FLOW] Login Process');
console.log('[AUTH:DEBUG] Validating credentials');
console.log('[AUTH:INFO] Sending login request');
console.log('[AUTH:SUCCESS] Login successful');
console.groupEnd();

// Table display for objects
console.table(userData);

// Performance timing
console.time('[API:PERF] User fetch');
await fetchUserData();
console.timeEnd('[API:PERF] User fetch');

// Conditional logging
const DEBUG = process.env.NODE_ENV !== 'production';
DEBUG && log.ui.debug('Development only message');
```

### React Debugging

#### React DevTools Integration
```javascript
// Component debugging with namespace
function UserProfile({ userId }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    
    useEffect(() => {
        log.ui.debug('UserProfile mounting', { userId });
        
        fetchUser(userId)
            .then(userData => {
                log.ui.info('User data loaded', userData);
                setUser(userData);
            })
            .catch(error => {
                log.ui.error('Failed to load user', error);
            })
            .finally(() => {
                setLoading(false);
                log.ui.debug('Loading complete');
            });
    }, [userId]);
    
    // Debug render cycles
    log.ui.debug('UserProfile render', { user, loading });
    
    return (
        <div>
            {loading ? <Spinner /> : <UserCard user={user} />}
        </div>
    );
}
```

#### State Debugging
```javascript
// Redux/Zustand debugging
const useDebugStore = (selector, name) => {
    const state = useStore(selector);
    
    useEffect(() => {
        log.state.debug(`${name} state changed`, state);
    }, [state, name]);
    
    return state;
};

// Usage
const user = useDebugStore(state => state.user, 'USER');
```

### Vue.js Debugging

```javascript
// Vue component debugging
export default {
    name: 'UserDashboard',
    data() {
        return {
            users: [],
            loading: true
        };
    },
    async mounted() {
        log.ui.debug('[VUE:MOUNT] UserDashboard mounted');
        await this.loadUsers();
    },
    methods: {
        async loadUsers() {
            try {
                log.api.debug('[VUE:API] Loading users');
                this.users = await userService.getAll();
                log.ui.info('[VUE:SUCCESS] Users loaded', this.users.length);
            } catch (error) {
                log.ui.error('[VUE:ERROR] Failed to load users', error);
            } finally {
                this.loading = false;
            }
        }
    },
    watch: {
        users: {
            handler(newUsers, oldUsers) {
                log.state.change('[VUE:WATCH] Users changed', {
                    from: oldUsers?.length,
                    to: newUsers?.length
                });
            },
            deep: true
        }
    }
};
```

## 🔧 Backend Debugging

### Node.js/Express Debugging

#### Middleware Debugging
```javascript
// Namespace logging middleware
const createLogger = (namespace) => ({
    debug: (msg, ...args) => console.log(`[${namespace}:DEBUG]`, msg, ...args),
    info: (msg, ...args) => console.log(`[${namespace}:INFO]`, msg, ...args),
    warn: (msg, ...args) => console.warn(`[${namespace}:WARN]`, msg, ...args),
    error: (msg, ...args) => console.error(`[${namespace}:ERROR]`, msg, ...args)
});

// Request logging middleware
app.use((req, res, next) => {
    const log = createLogger('REQ');
    const start = Date.now();
    
    log.info('Request started', {
        method: req.method,
        url: req.url,
        ip: req.ip,
        userAgent: req.get('User-Agent')
    });
    
    res.on('finish', () => {
        const duration = Date.now() - start;
        log.info('Request completed', {
            status: res.statusCode,
            duration: `${duration}ms`
        });
    });
    
    next();
});

// Error handling middleware
app.use((error, req, res, next) => {
    const log = createLogger('ERROR');
    
    log.error('Unhandled error', {
        error: error.message,
        stack: error.stack,
        url: req.url,
        method: req.method,
        body: req.body
    });
    
    res.status(500).json({ error: 'Internal server error' });
});
```

#### API Endpoint Debugging
```javascript
// User routes with debugging
app.get('/api/users/:id', async (req, res) => {
    const log = createLogger('USER_API');
    const { id } = req.params;
    
    try {
        log.debug('Fetching user', { id });
        
        const user = await User.findById(id);
        if (!user) {
            log.warn('User not found', { id });
            return res.status(404).json({ error: 'User not found' });
        }
        
        log.info('User fetched successfully', { id, email: user.email });
        res.json(user);
        
    } catch (error) {
        log.error('Database error', { id, error: error.message });
        res.status(500).json({ error: 'Database error' });
    }
});
```

### Python/Django Debugging

#### Django Namespace Logging
```python
import logging
from datetime import datetime

class NamespaceLogger:
    def __init__(self, namespace, enabled=True):
        self.namespace = namespace
        self.enabled = enabled
    
    def _log(self, level, message, *args, **kwargs):
        if not self.enabled:
            return
        timestamp = datetime.now().isoformat()
        prefix = f"[{self.namespace}:{level.upper()}]"
        print(f"{timestamp} {prefix} {message}", *args, **kwargs)
    
    def debug(self, message, *args, **kwargs):
        self._log('debug', message, *args, **kwargs)
    
    def info(self, message, *args, **kwargs):
        self._log('info', message, *args, **kwargs)
    
    def warn(self, message, *args, **kwargs):
        self._log('warn', message, *args, **kwargs)
    
    def error(self, message, *args, **kwargs):
        self._log('error', message, *args, **kwargs)

# Views debugging
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def user_list_view(request):
    log = NamespaceLogger('USER_VIEW')
    
    if request.method == 'GET':
        try:
            log.debug('Fetching user list')
            users = User.objects.all()
            log.info(f'Found {users.count()} users')
            
            user_data = [{'id': u.id, 'email': u.email} for u in users]
            return JsonResponse({'users': user_data})
            
        except Exception as e:
            log.error(f'Error fetching users: {str(e)}')
            return JsonResponse({'error': 'Database error'}, status=500)
    
    elif request.method == 'POST':
        try:
            log.debug('Creating new user')
            data = json.loads(request.body)
            
            user = User.objects.create(
                email=data['email'],
                name=data['name']
            )
            
            log.info(f'User created: {user.id}')
            return JsonResponse({'user': {'id': user.id, 'email': user.email}})
            
        except Exception as e:
            log.error(f'Error creating user: {str(e)}')
            return JsonResponse({'error': 'Creation failed'}, status=400)
```

#### FastAPI Debugging
```python
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import time

app = FastAPI()

# Middleware for request logging
@app.middleware("http")
async def log_requests(request, call_next):
    log = NamespaceLogger('REQ')
    start_time = time.time()
    
    log.info(f"Request: {request.method} {request.url}")
    
    response = await call_next(request)
    
    duration = time.time() - start_time
    log.info(f"Response: {response.status_code} ({duration:.3f}s)")
    
    return response

# API endpoints with debugging
@app.get("/users/{user_id}")
async def get_user(user_id: int):
    log = NamespaceLogger('USER_API')
    
    try:
        log.debug(f'Fetching user {user_id}')
        
        # Simulate database call
        user = await db.get_user(user_id)
        if not user:
            log.warn(f'User {user_id} not found')
            raise HTTPException(status_code=404, detail="User not found")
        
        log.info(f'User {user_id} fetched successfully')
        return user
        
    except Exception as e:
        log.error(f'Error fetching user {user_id}: {str(e)}')
        raise HTTPException(status_code=500, detail="Internal server error")
```

## 🗄️ Database Debugging

### SQL Query Debugging

#### MySQL/PostgreSQL
```sql
-- Enable query logging
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'table';

-- View slow queries
SELECT * FROM mysql.slow_log 
WHERE start_time > NOW() - INTERVAL 1 HOUR;

-- Explain query performance
EXPLAIN ANALYZE 
SELECT u.*, p.title 
FROM users u 
LEFT JOIN posts p ON u.id = p.user_id 
WHERE u.created_at > '2024-01-01';
```

#### ORM Debugging (Sequelize/Prisma)
```javascript
// Sequelize debugging
const sequelize = new Sequelize(database, username, password, {
    logging: (msg) => {
        log.db.debug('SQL Query', msg);
    }
});

// Prisma debugging
const prisma = new PrismaClient({
    log: [
        { level: 'query', emit: 'event' },
        { level: 'info', emit: 'event' },
        { level: 'warn', emit: 'event' },
        { level: 'error', emit: 'event' }
    ]
});

prisma.$on('query', (e) => {
    log.db.debug('Prisma Query', {
        query: e.query,
        params: e.params,
        duration: e.duration
    });
});
```

### Redis Debugging
```javascript
// Redis debugging wrapper
class DebugRedis {
    constructor(redisClient) {
        this.client = redisClient;
        this.log = createLogger('REDIS');
    }
    
    async get(key) {
        this.log.debug('GET', key);
        const start = Date.now();
        
        try {
            const result = await this.client.get(key);
            const duration = Date.now() - start;
            
            this.log.info('GET success', { key, duration, hit: !!result });
            return result;
        } catch (error) {
            this.log.error('GET failed', { key, error: error.message });
            throw error;
        }
    }
    
    async set(key, value, ttl) {
        this.log.debug('SET', { key, ttl });
        
        try {
            const result = await this.client.set(key, value, 'EX', ttl);
            this.log.info('SET success', { key, ttl });
            return result;
        } catch (error) {
            this.log.error('SET failed', { key, error: error.message });
            throw error;
        }
    }
}
```

## 🌐 API Debugging

### HTTP Client Debugging
```javascript
// Axios interceptors for debugging
axios.interceptors.request.use(
    (config) => {
        log.api.debug('Request sent', {
            method: config.method,
            url: config.url,
            data: config.data
        });
        config.metadata = { startTime: Date.now() };
        return config;
    },
    (error) => {
        log.api.error('Request error', error);
        return Promise.reject(error);
    }
);

axios.interceptors.response.use(
    (response) => {
        const duration = Date.now() - response.config.metadata.startTime;
        log.api.info('Response received', {
            status: response.status,
            url: response.config.url,
            duration: `${duration}ms`
        });
        return response;
    },
    (error) => {
        const duration = error.config?.metadata 
            ? Date.now() - error.config.metadata.startTime 
            : 0;
        
        log.api.error('Response error', {
            status: error.response?.status,
            url: error.config?.url,
            duration: `${duration}ms`,
            message: error.message
        });
        return Promise.reject(error);
    }
);
```

### GraphQL Debugging
```javascript
// Apollo Client debugging
const client = new ApolloClient({
    uri: '/graphql',
    link: ApolloLink.from([
        new ApolloLink((operation, forward) => {
            const log = createLogger('GRAPHQL');
            const start = Date.now();
            
            log.debug('Query started', {
                operationName: operation.operationName,
                variables: operation.variables
            });
            
            return forward(operation).map(result => {
                const duration = Date.now() - start;
                
                if (result.errors) {
                    log.error('Query failed', {
                        operationName: operation.operationName,
                        errors: result.errors,
                        duration: `${duration}ms`
                    });
                } else {
                    log.info('Query success', {
                        operationName: operation.operationName,
                        duration: `${duration}ms`
                    });
                }
                
                return result;
            });
        }),
        new HttpLink({ uri: '/graphql' })
    ])
});
```

## ⚡ Performance Debugging

### Browser Performance
```javascript
// Performance monitoring
class PerformanceMonitor {
    constructor() {
        this.log = createLogger('PERF');
    }
    
    measureComponent(name) {
        const start = performance.now();
        
        return () => {
            const end = performance.now();
            const duration = end - start;
            
            if (duration > 16) { // More than 1 frame at 60fps
                this.log.warn('Slow component render', {
                    component: name,
                    duration: `${duration.toFixed(2)}ms`
                });
            } else {
                this.log.debug('Component render', {
                    component: name,
                    duration: `${duration.toFixed(2)}ms`
                });
            }
        };
    }
    
    measureFunction(fn, name) {
        return async (...args) => {
            const start = performance.now();
            const result = await fn(...args);
            const end = performance.now();
            
            this.log.info('Function execution', {
                function: name,
                duration: `${(end - start).toFixed(2)}ms`
            });
            
            return result;
        };
    }
}

// Usage
const perfMonitor = new PerformanceMonitor();

function MyComponent() {
    const endMeasure = perfMonitor.measureComponent('MyComponent');
    
    // Component logic here
    
    useEffect(() => {
        endMeasure();
    });
    
    return <div>Component content</div>;
}
```

### Server Performance
```javascript
// Express performance monitoring
app.use((req, res, next) => {
    const log = createLogger('PERF');
    const start = Date.now();
    
    res.on('finish', () => {
        const duration = Date.now() - start;
        
        if (duration > 1000) {
            log.warn('Slow request', {
                method: req.method,
                url: req.url,
                duration: `${duration}ms`,
                status: res.statusCode
            });
        } else {
            log.debug('Request completed', {
                method: req.method,
                url: req.url,
                duration: `${duration}ms`,
                status: res.statusCode
            });
        }
    });
    
    next();
});
```

## 🚀 Production Debugging

### Error Tracking
```javascript
// Error boundary with logging
class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false };
        this.log = createLogger('ERROR_BOUNDARY');
    }
    
    static getDerivedStateFromError(error) {
        return { hasError: true };
    }
    
    componentDidCatch(error, errorInfo) {
        this.log.error('React error caught', {
            error: error.message,
            stack: error.stack,
            componentStack: errorInfo.componentStack,
            timestamp: new Date().toISOString()
        });
        
        // Send to error tracking service
        if (typeof window !== 'undefined' && window.Sentry) {
            window.Sentry.captureException(error, {
                contexts: {
                    react: {
                        componentStack: errorInfo.componentStack
                    }
                }
            });
        }
    }
    
    render() {
        if (this.state.hasError) {
            return <h1>Something went wrong.</h1>;
        }
        
        return this.props.children;
    }
}
```

### Health Checks
```javascript
// Health check endpoint with debugging
app.get('/health', async (req, res) => {
    const log = createLogger('HEALTH');
    const health = {
        status: 'ok',
        timestamp: new Date().toISOString(),
        services: {}
    };
    
    try {
        // Database check
        await db.query('SELECT 1');
        health.services.database = 'ok';
        log.debug('Database health check passed');
    } catch (error) {
        health.services.database = 'error';
        health.status = 'error';
        log.error('Database health check failed', error);
    }
    
    try {
        // Redis check
        await redis.ping();
        health.services.redis = 'ok';
        log.debug('Redis health check passed');
    } catch (error) {
        health.services.redis = 'error';
        health.status = 'error';
        log.error('Redis health check failed', error);
    }
    
    const statusCode = health.status === 'ok' ? 200 : 503;
    res.status(statusCode).json(health);
});
```

## 🔧 Tools & Extensions

### VS Code Extensions
- **REST Client** - API testing
- **Thunder Client** - Alternative to Postman
- **Database Client** - Database management
- **GitLens** - Git debugging
- **Error Lens** - Inline error display
- **Bracket Pair Colorizer** - Code structure debugging

### Browser Extensions
- **React Developer Tools** - React debugging
- **Vue.js DevTools** - Vue debugging
- **Redux DevTools** - State debugging
- **Apollo Client DevTools** - GraphQL debugging

### Command Line Tools
```bash
# Network debugging
alias check-port='netstat -tulpn | grep'
alias check-dns='nslookup'
alias check-ssl='openssl s_client -connect'

# Process debugging
alias check-process='ps aux | grep'
alias check-memory='free -h'
alias check-disk='df -h'

# Log monitoring
alias tail-logs='tail -f /var/log/nginx/error.log'
alias grep-logs='grep -r "ERROR" /var/log/'
```

## 💡 Best Practices

### 1. Consistent Logging
- Use namespace conventions consistently
- Include relevant context in logs
- Use appropriate log levels
- Clean up debug logs before production

### 2. Performance Monitoring
- Monitor critical paths
- Set performance budgets
- Use real user monitoring
- Track business metrics

### 3. Error Handling
- Log errors with full context
- Use error boundaries in React
- Implement graceful degradation
- Have rollback strategies

### 4. Testing Debug
- Write tests for debugging code
- Use debug mode in tests
- Mock external services
- Test error conditions

---

💡 **Remember**: Good debugging is about having the right information at the right time. Use namespace logging consistently and clean up before production!
