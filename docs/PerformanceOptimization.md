# ⚡ Performance Optimization Guide for Fullstack Developers

> **Mục tiêu**: Tối ưu hóa hiệu suất ứng dụng fullstack từ frontend đến backend, database và infrastructure

## 📋 Mục lục
- [Frontend Performance](#-frontend-performance)
- [Backend Performance](#-backend-performance)
- [Database Optimization](#-database-optimization)
- [API Performance](#-api-performance)
- [Caching Strategies](#-caching-strategies)
- [Monitoring & Metrics](#-monitoring--metrics)
- [Quick Performance Scripts](#-quick-performance-scripts)

---

## 🌐 Frontend Performance

### 🎯 Core Web Vitals Optimization

#### Largest Contentful Paint (LCP)
```html
<!-- 1. Preload Critical Resources -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/css/critical.css" as="style">
<link rel="preload" href="/images/hero.jpg" as="image">

<!-- 2. Optimize Images -->
<picture>
  <source srcset="/images/hero.webp" type="image/webp">
  <source srcset="/images/hero.jpg" type="image/jpeg">
  <img src="/images/hero.jpg" alt="Hero" loading="lazy" decoding="async">
</picture>

<!-- 3. Critical CSS Inline -->
<style>
  /* Critical above-the-fold CSS */
  .hero { display: block; }
</style>
```

#### First Input Delay (FID)
```javascript
// 1. Code Splitting with Dynamic Imports
const HeavyComponent = React.lazy(() => import('./HeavyComponent'));

// 2. Use Web Workers for Heavy Tasks
const worker = new Worker('/js/heavy-computation.worker.js');
worker.postMessage(data);
worker.onmessage = (e) => {
  console.log('Result:', e.data);
};

// 3. Debounce User Interactions
const debouncedHandler = debounce((value) => {
  // Heavy operation
}, 300);

// 4. Use requestIdleCallback for Non-Critical Tasks
const scheduleWork = (task) => {
  if ('requestIdleCallback' in window) {
    requestIdleCallback(task);
  } else {
    setTimeout(task, 0);
  }
};
```

#### Cumulative Layout Shift (CLS)
```css
/* 1. Reserve Space for Images */
.image-container {
  aspect-ratio: 16 / 9;
  width: 100%;
}

/* 2. Font Display Optimization */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont.woff2') format('woff2');
  font-display: swap; /* Prevents invisible text during font swap */
}

/* 3. Skeleton Screens */
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### 🚀 React Performance Optimization

#### Component Optimization
```javascript
// 1. React.memo for Component Memoization
const ExpensiveComponent = React.memo(({ data, callback }) => {
  return <div>{data.map(item => <Item key={item.id} {...item} />)}</div>;
}, (prevProps, nextProps) => {
  // Custom comparison
  return prevProps.data.length === nextProps.data.length;
});

// 2. useMemo for Expensive Calculations
const MemoizedComponent = ({ items, filter }) => {
  const filteredItems = useMemo(() => {
    console.log('Filtering items...');
    return items.filter(item => item.category === filter);
  }, [items, filter]);

  const expensiveValue = useMemo(() => {
    console.log('Computing expensive value...');
    return items.reduce((sum, item) => sum + item.value, 0);
  }, [items]);

  return <div>{/* render */}</div>;
};

// 3. useCallback for Function Memoization
const ListComponent = ({ items }) => {
  const [selectedItems, setSelectedItems] = useState([]);

  const handleItemClick = useCallback((itemId) => {
    setSelectedItems(prev => 
      prev.includes(itemId) 
        ? prev.filter(id => id !== itemId)
        : [...prev, itemId]
    );
  }, []);

  return (
    <div>
      {items.map(item => (
        <Item 
          key={item.id} 
          item={item} 
          onClick={handleItemClick}
          isSelected={selectedItems.includes(item.id)}
        />
      ))}
    </div>
  );
};

// 4. Virtual Scrolling for Large Lists
import { FixedSizeList as List } from 'react-window';

const VirtualizedList = ({ items }) => {
  const Row = ({ index, style }) => (
    <div style={style}>
      {items[index].name}
    </div>
  );

  return (
    <List
      height={600}
      itemCount={items.length}
      itemSize={50}
      width="100%"
    >
      {Row}
    </List>
  );
};
```

#### State Management Optimization
```javascript
// 1. State Splitting
// Bad: Single large state object
const [state, setState] = useState({
  user: null,
  posts: [],
  comments: [],
  loading: false
});

// Good: Split into logical pieces
const [user, setUser] = useState(null);
const [posts, setPosts] = useState([]);
const [comments, setComments] = useState([]);
const [loading, setLoading] = useState(false);

// 2. useReducer for Complex State Logic
const initialState = { items: [], loading: false, error: null };

function itemsReducer(state, action) {
  switch (action.type) {
    case 'LOAD_START':
      return { ...state, loading: true, error: null };
    case 'LOAD_SUCCESS':
      return { ...state, loading: false, items: action.payload };
    case 'LOAD_ERROR':
      return { ...state, loading: false, error: action.payload };
    default:
      return state;
  }
}

const [state, dispatch] = useReducer(itemsReducer, initialState);

// 3. Context Optimization
const ThemeContext = createContext();
const UserContext = createContext();

// Split contexts to prevent unnecessary re-renders
const App = () => (
  <ThemeProvider>
    <UserProvider>
      <AppContent />
    </UserProvider>
  </ThemeProvider>
);
```

### 🎨 CSS Performance

#### Critical CSS Strategy
```css
/* critical.css - Above the fold styles */
body { margin: 0; font-family: Arial, sans-serif; }
.header { background: #000; color: #fff; padding: 1rem; }
.hero { height: 100vh; background: url('/hero.jpg'); }

/* Load non-critical CSS asynchronously */
```

```html
<style>
  /* Inline critical CSS */
</style>
<link rel="preload" href="/css/non-critical.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="/css/non-critical.css"></noscript>
```

#### CSS Optimization Techniques
```css
/* 1. Use CSS containment */
.card {
  contain: layout style paint;
}

/* 2. Optimize animations */
.smooth-animation {
  will-change: transform;
  transform: translateZ(0); /* Force GPU acceleration */
}

/* 3. Use efficient selectors */
/* Bad */
.container .content .item .title { }

/* Good */
.item-title { }

/* 4. Minimize reflows and repaints */
.optimized {
  transform: translateX(100px); /* Better than left: 100px */
  opacity: 0.5; /* Better than visibility */
}
```

---

## ⚙️ Backend Performance

### 🐍 Python/Django Optimization

#### Database Query Optimization
```python
# 1. Use select_related for ForeignKey
# Bad
users = User.objects.all()
for user in users:
    print(user.profile.bio)  # N+1 queries

# Good
users = User.objects.select_related('profile').all()
for user in users:
    print(user.profile.bio)  # 1 query

# 2. Use prefetch_related for ManyToMany/Reverse ForeignKey
# Bad
users = User.objects.all()
for user in users:
    for post in user.posts.all():  # N+1 queries
        print(post.title)

# Good
users = User.objects.prefetch_related('posts').all()
for user in users:
    for post in user.posts.all():  # 1 + 1 queries
        print(post.title)

# 3. Use only() and defer() for Field Selection
# Only specific fields
users = User.objects.only('id', 'username', 'email')

# Defer large fields
users = User.objects.defer('large_text_field', 'binary_data')

# 4. Bulk Operations
# Bad
for item in items:
    Item.objects.create(**item)

# Good
Item.objects.bulk_create([Item(**item) for item in items])

# Bulk update
Item.objects.bulk_update(items, ['field1', 'field2'])
```

#### Caching in Django
```python
# 1. View-level Caching
from django.views.decorators.cache import cache_page

@cache_page(60 * 15)  # Cache for 15 minutes
def expensive_view(request):
    # Expensive operation
    return render(request, 'template.html', context)

# 2. Template Fragment Caching
# In template
{% load cache %}
{% cache 500 sidebar request.user.username %}
    <!-- expensive template code -->
{% endcache %}

# 3. Low-level Cache API
from django.core.cache import cache

def get_user_posts(user_id):
    cache_key = f'user_posts_{user_id}'
    posts = cache.get(cache_key)
    
    if posts is None:
        posts = Post.objects.filter(author_id=user_id).select_related('author')
        cache.set(cache_key, posts, 300)  # Cache for 5 minutes
    
    return posts

# 4. Cache Invalidation
def update_user_post(post_id, data):
    post = Post.objects.get(id=post_id)
    post.title = data['title']
    post.save()
    
    # Invalidate related caches
    cache.delete(f'user_posts_{post.author_id}')
    cache.delete(f'post_detail_{post_id}')
```

#### Async Django Views
```python
# 1. Async Views (Django 3.1+)
import asyncio
import aiohttp
from django.http import JsonResponse

async def async_view(request):
    # Async database operations
    user = await User.objects.aget(id=request.user.id)
    
    # Concurrent API calls
    async with aiohttp.ClientSession() as session:
        tasks = [
            fetch_external_data(session, url1),
            fetch_external_data(session, url2)
        ]
        results = await asyncio.gather(*tasks)
    
    return JsonResponse({'data': results})

async def fetch_external_data(session, url):
    async with session.get(url) as response:
        return await response.json()

# 2. Database Connection Pooling
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'OPTIONS': {
            'MAX_CONNS': 20,
            'MIN_CONNS': 5,
        }
    }
}
```

### 🟢 Node.js Performance

#### Event Loop Optimization
```javascript
// 1. Avoid Blocking Operations
const fs = require('fs').promises;

// Bad - Blocking
const data = fs.readFileSync('large-file.txt');

// Good - Non-blocking
const data = await fs.readFile('large-file.txt');

// 2. Use Streams for Large Data
const fs = require('fs');
const zlib = require('zlib');

const readStream = fs.createReadStream('input.txt');
const writeStream = fs.createWriteStream('output.txt.gz');
const gzipStream = zlib.createGzip();

readStream
  .pipe(gzipStream)
  .pipe(writeStream)
  .on('finish', () => console.log('Compression complete'));

// 3. Worker Threads for CPU-Intensive Tasks
const { Worker, isMainThread, parentPort, workerData } = require('worker_threads');

if (isMainThread) {
  // Main thread
  const worker = new Worker(__filename, {
    workerData: { numbers: [1, 2, 3, 4, 5] }
  });
  
  worker.on('message', (result) => {
    console.log('Result:', result);
  });
} else {
  // Worker thread
  const { numbers } = workerData;
  const result = numbers.reduce((sum, num) => sum + num * num, 0);
  parentPort.postMessage(result);
}
```

#### Express.js Optimization
```javascript
// 1. Compression Middleware
const compression = require('compression');
app.use(compression());

// 2. Static File Optimization
const express = require('express');
const path = require('path');

app.use('/static', express.static('public', {
  maxAge: '1y',  // Cache for 1 year
  etag: true,
  lastModified: true
}));

// 3. Request Rate Limiting
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests, please try again later.'
});

app.use('/api/', limiter);

// 4. Connection Pooling
const mysql = require('mysql2');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'username',
  password: 'password',
  database: 'mydb',
  connectionLimit: 10,
  queueLimit: 0,
  acquireTimeout: 60000,
  timeout: 60000
});

// 5. Cluster Mode
const cluster = require('cluster');
const numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
  console.log(`Master ${process.pid} is running`);
  
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }
  
  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork();
  });
} else {
  require('./app.js');
  console.log(`Worker ${process.pid} started`);
}
```

---

## 🗄️ Database Optimization

### 🐬 MySQL Performance Tuning

#### Index Optimization
```sql
-- 1. Create Efficient Indexes
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_post_author_created ON posts(author_id, created_at);
CREATE INDEX idx_user_status_created ON users(status, created_at) WHERE status = 'active';

-- 2. Composite Index Strategy
-- For query: SELECT * FROM orders WHERE user_id = 123 AND status = 'pending' ORDER BY created_at DESC
CREATE INDEX idx_orders_user_status_created ON orders(user_id, status, created_at DESC);

-- 3. Covering Indexes
-- For query: SELECT id, title FROM posts WHERE author_id = 123
CREATE INDEX idx_posts_author_covering ON posts(author_id) INCLUDE (id, title);

-- 4. Index Analysis
EXPLAIN SELECT * FROM users WHERE email = 'user@example.com';
SHOW INDEX FROM users;

-- Check unused indexes
SELECT 
    s.table_name,
    s.index_name,
    s.cardinality,
    s.non_unique
FROM information_schema.statistics s
LEFT JOIN information_schema.index_statistics i 
    ON s.table_schema = i.table_schema 
    AND s.table_name = i.table_name 
    AND s.index_name = i.index_name
WHERE s.table_schema = 'your_database' 
    AND i.index_name IS NULL;
```

#### Query Optimization
```sql
-- 1. Avoid SELECT *
-- Bad
SELECT * FROM users WHERE status = 'active';

-- Good
SELECT id, username, email FROM users WHERE status = 'active';

-- 2. Use LIMIT for Large Results
SELECT id, title FROM posts ORDER BY created_at DESC LIMIT 20 OFFSET 0;

-- 3. Optimize JOINs
-- Bad - Cartesian product risk
SELECT u.username, p.title 
FROM users u, posts p 
WHERE u.id = p.author_id;

-- Good - Explicit JOIN
SELECT u.username, p.title 
FROM users u 
INNER JOIN posts p ON u.id = p.author_id;

-- 4. Use EXISTS instead of IN for subqueries
-- Bad
SELECT * FROM users WHERE id IN (SELECT author_id FROM posts WHERE status = 'published');

-- Good
SELECT * FROM users u WHERE EXISTS (SELECT 1 FROM posts p WHERE p.author_id = u.id AND p.status = 'published');

-- 5. Optimize WHERE clauses
-- Bad - Function on column prevents index usage
SELECT * FROM users WHERE YEAR(created_at) = 2023;

-- Good - Range condition allows index usage
SELECT * FROM users WHERE created_at >= '2023-01-01' AND created_at < '2024-01-01';
```

#### MySQL Configuration Tuning
```ini
# my.cnf optimization
[mysqld]
# Buffer Pool - Set to 70-80% of available RAM
innodb_buffer_pool_size = 8G
innodb_buffer_pool_instances = 8

# Log files
innodb_log_file_size = 1G
innodb_log_buffer_size = 64M

# Connection settings
max_connections = 200
max_connect_errors = 1000000

# Query cache (MySQL 5.7 and earlier)
query_cache_type = 1
query_cache_size = 256M
query_cache_limit = 2M

# Temporary tables
tmp_table_size = 256M
max_heap_table_size = 256M

# MyISAM settings
key_buffer_size = 128M

# InnoDB settings
innodb_flush_method = O_DIRECT
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 2
```

### 🐘 PostgreSQL Optimization

#### Index Strategies
```sql
-- 1. B-tree Indexes (default)
CREATE INDEX idx_users_email ON users(email);

-- 2. Partial Indexes
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';

-- 3. Expression Indexes
CREATE INDEX idx_users_lower_email ON users(lower(email));

-- 4. Multi-column Indexes
CREATE INDEX idx_posts_author_status_created ON posts(author_id, status, created_at DESC);

-- 5. GIN Indexes for JSON and Arrays
CREATE INDEX idx_user_tags ON users USING GIN(tags);
CREATE INDEX idx_user_metadata ON users USING GIN(metadata);

-- 6. GiST Indexes for Full-text Search
CREATE INDEX idx_posts_fulltext ON posts USING GIN(to_tsvector('english', title || ' ' || content));
```

#### Query Performance
```sql
-- 1. Use EXPLAIN ANALYZE
EXPLAIN (ANALYZE, BUFFERS) 
SELECT u.username, p.title 
FROM users u 
JOIN posts p ON u.id = p.author_id 
WHERE u.status = 'active';

-- 2. Window Functions for Analytics
-- Bad - Multiple subqueries
SELECT 
    user_id,
    score,
    (SELECT AVG(score) FROM user_scores) as avg_score,
    (SELECT COUNT(*) FROM user_scores) as total_users
FROM user_scores;

-- Good - Window functions
SELECT 
    user_id,
    score,
    AVG(score) OVER () as avg_score,
    COUNT(*) OVER () as total_users
FROM user_scores;

-- 3. Efficient Pagination
-- Bad - OFFSET becomes slow with large offsets
SELECT * FROM posts ORDER BY created_at DESC LIMIT 20 OFFSET 10000;

-- Good - Cursor-based pagination
SELECT * FROM posts 
WHERE created_at < '2023-01-01 12:00:00'
ORDER BY created_at DESC 
LIMIT 20;

-- 4. Batch Processing with CTEs
WITH batch_update AS (
    SELECT id FROM users 
    WHERE last_login < NOW() - INTERVAL '1 year'
    LIMIT 1000
)
UPDATE users 
SET status = 'inactive' 
WHERE id IN (SELECT id FROM batch_update);
```

#### PostgreSQL Configuration
```conf
# postgresql.conf optimization

# Memory settings
shared_buffers = 2GB                    # 25% of RAM
effective_cache_size = 6GB              # 75% of RAM
work_mem = 32MB                         # Per connection sort/hash
maintenance_work_mem = 512MB            # For VACUUM, CREATE INDEX

# Checkpoint settings
checkpoint_completion_target = 0.9
wal_buffers = 64MB
checkpoint_timeout = 10min

# Connection settings
max_connections = 200
max_prepared_transactions = 200

# Query planner
random_page_cost = 1.1                  # For SSD storage
effective_io_concurrency = 200          # For SSD storage

# Logging
log_min_duration_statement = 1000       # Log slow queries
log_statement = 'ddl'                   # Log DDL statements
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
```

### 🍃 MongoDB Optimization

#### Index Strategies
```javascript
// 1. Single Field Indexes
db.users.createIndex({ email: 1 });
db.posts.createIndex({ createdAt: -1 });

// 2. Compound Indexes
db.posts.createIndex({ authorId: 1, status: 1, createdAt: -1 });

// 3. Text Indexes for Search
db.posts.createIndex({ title: "text", content: "text" });

// 4. Sparse Indexes
db.users.createIndex({ phoneNumber: 1 }, { sparse: true });

// 5. TTL Indexes for Expiration
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 3600 });

// 6. Partial Indexes
db.users.createIndex(
    { email: 1 },
    { partialFilterExpression: { status: "active" } }
);
```

#### Query Optimization
```javascript
// 1. Use explain() to analyze queries
db.users.find({ email: "user@example.com" }).explain("executionStats");

// 2. Efficient field selection
// Bad
db.users.find({ status: "active" });

// Good
db.users.find({ status: "active" }, { _id: 1, name: 1, email: 1 });

// 3. Use aggregation pipeline efficiently
// Bad - Multiple queries
const users = db.users.find({ status: "active" });
const userIds = users.map(u => u._id);
const posts = db.posts.find({ authorId: { $in: userIds } });

// Good - Single aggregation
db.users.aggregate([
    { $match: { status: "active" } },
    { $lookup: {
        from: "posts",
        localField: "_id",
        foreignField: "authorId",
        as: "posts"
    }},
    { $project: { name: 1, email: 1, postCount: { $size: "$posts" } }}
]);

// 4. Efficient pagination
// Bad - skip() is slow for large offsets
db.posts.find().skip(10000).limit(20);

// Good - Range queries
db.posts.find({ _id: { $gt: lastSeenId } }).limit(20);
```

---

## 🔌 API Performance

### 🚀 REST API Optimization

#### Response Optimization
```javascript
// 1. Implement API Response Compression
const compression = require('compression');
app.use(compression({
    level: 6,
    threshold: 1024,
    filter: (req, res) => {
        if (req.headers['x-no-compression']) {
            return false;
        }
        return compression.filter(req, res);
    }
}));

// 2. Pagination and Filtering
app.get('/api/posts', (req, res) => {
    const {
        page = 1,
        limit = 20,
        sort = 'createdAt',
        order = 'desc',
        search,
        category
    } = req.query;

    const offset = (page - 1) * limit;
    
    let query = Post.find();
    
    // Apply filters
    if (search) {
        query = query.where('title').regex(new RegExp(search, 'i'));
    }
    
    if (category) {
        query = query.where('category').equals(category);
    }
    
    // Apply sorting and pagination
    query = query
        .sort({ [sort]: order === 'desc' ? -1 : 1 })
        .skip(offset)
        .limit(parseInt(limit));

    // Execute query with total count
    Promise.all([
        query.exec(),
        Post.countDocuments(query.getFilter())
    ]).then(([posts, total]) => {
        res.json({
            data: posts,
            pagination: {
                page: parseInt(page),
                limit: parseInt(limit),
                total,
                pages: Math.ceil(total / limit)
            }
        });
    });
});

// 3. Field Selection (Sparse Fieldsets)
app.get('/api/users', (req, res) => {
    const { fields } = req.query;
    
    let selectFields = 'id username email';
    if (fields) {
        selectFields = fields.split(',').join(' ');
    }
    
    User.find()
        .select(selectFields)
        .then(users => res.json(users));
});

// 4. Batch Requests
app.post('/api/batch', (req, res) => {
    const { requests } = req.body;
    
    const promises = requests.map(async (request) => {
        try {
            const result = await processRequest(request);
            return { id: request.id, status: 'success', data: result };
        } catch (error) {
            return { id: request.id, status: 'error', error: error.message };
        }
    });
    
    Promise.all(promises).then(results => {
        res.json({ results });
    });
});
```

#### Caching Headers
```javascript
// 1. ETags for Conditional Requests
app.get('/api/posts/:id', (req, res) => {
    const post = await Post.findById(req.params.id);
    
    if (!post) {
        return res.status(404).json({ error: 'Post not found' });
    }
    
    const etag = generateETag(post);
    
    if (req.headers['if-none-match'] === etag) {
        return res.status(304).end();
    }
    
    res.set('ETag', etag);
    res.set('Cache-Control', 'private, max-age=300'); // 5 minutes
    res.json(post);
});

// 2. Last-Modified Headers
app.get('/api/posts/:id', (req, res) => {
    const post = await Post.findById(req.params.id);
    const lastModified = post.updatedAt.toUTCString();
    
    if (req.headers['if-modified-since'] === lastModified) {
        return res.status(304).end();
    }
    
    res.set('Last-Modified', lastModified);
    res.json(post);
});

// 3. Cache-Control Headers
const setCacheHeaders = (maxAge, isPublic = false) => {
    return (req, res, next) => {
        const cacheControl = isPublic ? 'public' : 'private';
        res.set('Cache-Control', `${cacheControl}, max-age=${maxAge}`);
        next();
    };
};

app.get('/api/public-data', setCacheHeaders(3600, true), handler);
app.get('/api/user-data', setCacheHeaders(300, false), handler);
```

### ⚡ GraphQL Optimization

#### Query Optimization
```javascript
// 1. DataLoader for N+1 Problem Prevention
const DataLoader = require('dataloader');

const userLoader = new DataLoader(async (userIds) => {
    const users = await User.find({ _id: { $in: userIds } });
    return userIds.map(id => users.find(user => user._id.equals(id)));
});

const resolvers = {
    Post: {
        author: (parent) => userLoader.load(parent.authorId)
    }
};

// 2. Query Complexity Analysis
const depthLimit = require('graphql-depth-limit');
const costAnalysis = require('graphql-cost-analysis');

const server = new ApolloServer({
    typeDefs,
    resolvers,
    validationRules: [
        depthLimit(10),
        costAnalysis({
            maximumCost: 1000,
            defaultCost: 1,
            scalarCost: 1,
            objectCost: 2,
            listFactor: 10,
            introspectionCost: 1000
        })
    ]
});

// 3. Query Caching
const { createHash } = require('crypto');
const Redis = require('redis');
const redis = Redis.createClient();

const cacheResolver = (resolver, ttl = 300) => {
    return async (parent, args, context, info) => {
        const key = createHash('sha256')
            .update(JSON.stringify({ parent, args, query: info.fieldName }))
            .digest('hex');
        
        const cached = await redis.get(key);
        if (cached) {
            return JSON.parse(cached);
        }
        
        const result = await resolver(parent, args, context, info);
        await redis.setex(key, ttl, JSON.stringify(result));
        
        return result;
    };
};

// Apply caching to resolvers
const resolvers = {
    Query: {
        posts: cacheResolver(async () => {
            return await Post.find().limit(50);
        }, 600)
    }
};
```

---

## 🗄️ Caching Strategies

### 🔴 Redis Caching Patterns

#### Cache Patterns Implementation
```javascript
// 1. Cache-Aside Pattern
class CacheService {
    constructor(redisClient, defaultTTL = 3600) {
        this.redis = redisClient;
        this.defaultTTL = defaultTTL;
    }
    
    async get(key, fetchFunction, ttl = this.defaultTTL) {
        // Try to get from cache
        const cached = await this.redis.get(key);
        if (cached) {
            return JSON.parse(cached);
        }
        
        // Fetch from source
        const data = await fetchFunction();
        
        // Store in cache
        await this.redis.setex(key, ttl, JSON.stringify(data));
        
        return data;
    }
    
    async set(key, data, ttl = this.defaultTTL) {
        await this.redis.setex(key, ttl, JSON.stringify(data));
    }
    
    async invalidate(pattern) {
        const keys = await this.redis.keys(pattern);
        if (keys.length > 0) {
            await this.redis.del(...keys);
        }
    }
}

// Usage
const cache = new CacheService(redisClient);

app.get('/api/user/:id', async (req, res) => {
    const userId = req.params.id;
    
    const user = await cache.get(
        `user:${userId}`,
        () => User.findById(userId),
        1800 // 30 minutes
    );
    
    res.json(user);
});

// 2. Write-Through Pattern
class WriteThroughCache {
    async updateUser(userId, userData) {
        // Update database
        const user = await User.findByIdAndUpdate(userId, userData, { new: true });
        
        // Update cache
        await this.redis.setex(`user:${userId}`, 3600, JSON.stringify(user));
        
        return user;
    }
}

// 3. Write-Behind (Write-Back) Pattern
class WriteBehindCache {
    constructor() {
        this.writeQueue = [];
        this.processQueue();
    }
    
    async updateUser(userId, userData) {
        // Update cache immediately
        const cacheKey = `user:${userId}`;
        await this.redis.setex(cacheKey, 3600, JSON.stringify(userData));
        
        // Queue database write
        this.writeQueue.push({ userId, userData, timestamp: Date.now() });
        
        return userData;
    }
    
    async processQueue() {
        setInterval(async () => {
            const batch = this.writeQueue.splice(0, 100);
            
            for (const item of batch) {
                try {
                    await User.findByIdAndUpdate(item.userId, item.userData);
                } catch (error) {
                    console.error('Failed to write to database:', error);
                    // Re-queue or handle error
                }
            }
        }, 5000); // Process every 5 seconds
    }
}
```

#### Cache Invalidation Strategies
```javascript
// 1. Tag-Based Invalidation
class TaggedCache {
    async set(key, data, tags = [], ttl = 3600) {
        // Store data
        await this.redis.setex(key, ttl, JSON.stringify(data));
        
        // Store tags mapping
        for (const tag of tags) {
            await this.redis.sadd(`tag:${tag}`, key);
            await this.redis.expire(`tag:${tag}`, ttl);
        }
    }
    
    async invalidateByTag(tag) {
        const keys = await this.redis.smembers(`tag:${tag}`);
        
        if (keys.length > 0) {
            await this.redis.del(...keys);
            await this.redis.del(`tag:${tag}`);
        }
    }
}

// Usage
await taggedCache.set('user:123', userData, ['user', 'profile', 'user:123']);
await taggedCache.invalidateByTag('user'); // Invalidates all user-related cache

// 2. Hierarchical Cache Invalidation
class HierarchicalCache {
    async invalidateHierarchy(pattern) {
        const levels = pattern.split(':');
        
        for (let i = 1; i <= levels.length; i++) {
            const currentPattern = levels.slice(0, i).join(':') + ':*';
            const keys = await this.redis.keys(currentPattern);
            
            if (keys.length > 0) {
                await this.redis.del(...keys);
            }
        }
    }
}

// Invalidate user:123:* (all caches for user 123)
await hierarchicalCache.invalidateHierarchy('user:123');
```

### 💾 Application-Level Caching

#### In-Memory Caching
```javascript
// 1. LRU Cache Implementation
class LRUCache {
    constructor(maxSize = 1000) {
        this.maxSize = maxSize;
        this.cache = new Map();
    }
    
    get(key) {
        if (this.cache.has(key)) {
            const value = this.cache.get(key);
            // Move to end (most recently used)
            this.cache.delete(key);
            this.cache.set(key, value);
            return value;
        }
        return null;
    }
    
    set(key, value) {
        if (this.cache.has(key)) {
            this.cache.delete(key);
        } else if (this.cache.size >= this.maxSize) {
            // Remove least recently used (first item)
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }
        
        this.cache.set(key, value);
    }
    
    clear() {
        this.cache.clear();
    }
    
    size() {
        return this.cache.size;
    }
}

// 2. TTL Cache
class TTLCache {
    constructor() {
        this.cache = new Map();
        this.timers = new Map();
    }
    
    set(key, value, ttl = 3600000) { // Default 1 hour
        // Clear existing timer
        if (this.timers.has(key)) {
            clearTimeout(this.timers.get(key));
        }
        
        // Set value
        this.cache.set(key, value);
        
        // Set expiration timer
        const timer = setTimeout(() => {
            this.cache.delete(key);
            this.timers.delete(key);
        }, ttl);
        
        this.timers.set(key, timer);
    }
    
    get(key) {
        return this.cache.get(key);
    }
    
    delete(key) {
        if (this.timers.has(key)) {
            clearTimeout(this.timers.get(key));
            this.timers.delete(key);
        }
        return this.cache.delete(key);
    }
}

// 3. Multi-Level Cache
class MultiLevelCache {
    constructor(l1Cache, l2Cache) {
        this.l1 = l1Cache; // In-memory cache
        this.l2 = l2Cache; // Redis cache
    }
    
    async get(key) {
        // Try L1 cache first
        let value = this.l1.get(key);
        if (value) {
            return value;
        }
        
        // Try L2 cache
        const cached = await this.l2.get(key);
        if (cached) {
            value = JSON.parse(cached);
            // Populate L1 cache
            this.l1.set(key, value);
            return value;
        }
        
        return null;
    }
    
    async set(key, value, ttl = 3600) {
        // Set in both caches
        this.l1.set(key, value);
        await this.l2.setex(key, ttl, JSON.stringify(value));
    }
    
    async delete(key) {
        this.l1.delete(key);
        await this.l2.del(key);
    }
}
```

---

## 📊 Monitoring & Metrics

### 📈 Performance Monitoring

#### Application Performance Monitoring (APM)
```javascript
// 1. Custom Performance Middleware
const performanceMiddleware = (req, res, next) => {
    const startTime = process.hrtime.bigint();
    const startMemory = process.memoryUsage().heapUsed;
    
    res.on('finish', () => {
        const endTime = process.hrtime.bigint();
        const endMemory = process.memoryUsage().heapUsed;
        
        const duration = Number(endTime - startTime) / 1e6; // Convert to ms
        const memoryDelta = endMemory - startMemory;
        
        console.log({
            method: req.method,
            url: req.url,
            statusCode: res.statusCode,
            duration: `${duration.toFixed(2)}ms`,
            memoryDelta: `${(memoryDelta / 1024 / 1024).toFixed(2)}MB`,
            timestamp: new Date().toISOString()
        });
        
        // Send to monitoring service
        if (duration > 1000) { // Slow request threshold
            sendToMonitoring({
                type: 'slow_request',
                url: req.url,
                duration,
                timestamp: Date.now()
            });
        }
    });
    
    next();
};

app.use(performanceMiddleware);

// 2. Database Query Monitoring
class DatabaseMonitor {
    constructor() {
        this.queryMetrics = new Map();
    }
    
    logQuery(query, duration, rowCount) {
        const queryHash = this.hashQuery(query);
        
        if (!this.queryMetrics.has(queryHash)) {
            this.queryMetrics.set(queryHash, {
                query: query.substring(0, 100),
                count: 0,
                totalDuration: 0,
                maxDuration: 0,
                avgRowCount: 0
            });
        }
        
        const metrics = this.queryMetrics.get(queryHash);
        metrics.count++;
        metrics.totalDuration += duration;
        metrics.maxDuration = Math.max(metrics.maxDuration, duration);
        metrics.avgRowCount = (metrics.avgRowCount + rowCount) / 2;
        
        // Alert on slow queries
        if (duration > 1000) {
            console.warn(`Slow query detected: ${query} (${duration}ms)`);
        }
    }
    
    getTopSlowQueries(limit = 10) {
        return Array.from(this.queryMetrics.values())
            .sort((a, b) => (b.totalDuration / b.count) - (a.totalDuration / a.count))
            .slice(0, limit);
    }
    
    hashQuery(query) {
        return require('crypto').createHash('md5').update(query).digest('hex');
    }
}

// 3. System Metrics Collection
class SystemMonitor {
    constructor() {
        this.metrics = {
            cpu: [],
            memory: [],
            eventLoop: []
        };
        
        this.startMonitoring();
    }
    
    startMonitoring() {
        setInterval(() => {
            this.collectMetrics();
        }, 5000); // Collect every 5 seconds
    }
    
    collectMetrics() {
        const usage = process.cpuUsage();
        const memory = process.memoryUsage();
        
        this.metrics.cpu.push({
            user: usage.user / 1000,
            system: usage.system / 1000,
            timestamp: Date.now()
        });
        
        this.metrics.memory.push({
            rss: memory.rss / 1024 / 1024,
            heapTotal: memory.heapTotal / 1024 / 1024,
            heapUsed: memory.heapUsed / 1024 / 1024,
            external: memory.external / 1024 / 1024,
            timestamp: Date.now()
        });
        
        // Event loop lag
        const start = process.hrtime.bigint();
        setImmediate(() => {
            const lag = Number(process.hrtime.bigint() - start) / 1e6;
            this.metrics.eventLoop.push({
                lag,
                timestamp: Date.now()
            });
            
            if (lag > 100) {
                console.warn(`High event loop lag: ${lag.toFixed(2)}ms`);
            }
        });
        
        // Keep only last 100 measurements
        this.metrics.cpu = this.metrics.cpu.slice(-100);
        this.metrics.memory = this.metrics.memory.slice(-100);
        this.metrics.eventLoop = this.metrics.eventLoop.slice(-100);
    }
    
    getMetrics() {
        return this.metrics;
    }
}
```

#### Health Check Endpoints
```javascript
// 1. Comprehensive Health Check
app.get('/health', async (req, res) => {
    const health = {
        status: 'OK',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        version: process.version,
        environment: process.env.NODE_ENV
    };
    
    // Database health
    try {
        await db.ping();
        health.database = 'OK';
    } catch (error) {
        health.database = 'ERROR';
        health.status = 'ERROR';
    }
    
    // Redis health
    try {
        await redis.ping();
        health.redis = 'OK';
    } catch (error) {
        health.redis = 'ERROR';
        health.status = 'ERROR';
    }
    
    // Memory usage
    const memory = process.memoryUsage();
    health.memory = {
        rss: `${(memory.rss / 1024 / 1024).toFixed(2)}MB`,
        heapTotal: `${(memory.heapTotal / 1024 / 1024).toFixed(2)}MB`,
        heapUsed: `${(memory.heapUsed / 1024 / 1024).toFixed(2)}MB`
    };
    
    // CPU usage
    const cpuUsage = process.cpuUsage();
    health.cpu = {
        user: `${cpuUsage.user / 1000}ms`,
        system: `${cpuUsage.system / 1000}ms`
    };
    
    const statusCode = health.status === 'OK' ? 200 : 503;
    res.status(statusCode).json(health);
});

// 2. Readiness and Liveness Probes
app.get('/ready', async (req, res) => {
    // Check if application is ready to serve requests
    try {
        await db.ping();
        await redis.ping();
        res.status(200).json({ status: 'ready' });
    } catch (error) {
        res.status(503).json({ status: 'not ready', error: error.message });
    }
});

app.get('/live', (req, res) => {
    // Simple liveness check
    res.status(200).json({ status: 'alive', timestamp: Date.now() });
});
```

---

## ⚡ Quick Performance Scripts

### 🔧 Performance Testing Scripts

#### Load Testing with Artillery
```yaml
# artillery-config.yml
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 10
      name: "Warm up"
    - duration: 120
      arrivalRate: 50
      name: "Ramp up load"
    - duration: 300
      arrivalRate: 100
      name: "Sustained load"

scenarios:
  - name: "API Load Test"
    weight: 70
    flow:
      - get:
          url: "/api/posts"
      - think: 1
      - post:
          url: "/api/posts"
          json:
            title: "Test Post {{ $randomString() }}"
            content: "This is a test post content"
      - think: 2
      - get:
          url: "/api/posts/{{ id }}"

  - name: "User Flow"
    weight: 30
    flow:
      - post:
          url: "/api/auth/login"
          json:
            email: "user{{ $randomInt(1, 1000) }}@example.com"
            password: "password123"
          capture:
            json: "$.token"
            as: "authToken"
      - get:
          url: "/api/user/profile"
          headers:
            Authorization: "Bearer {{ authToken }}"
```

#### Database Performance Scripts
```bash
#!/bin/bash
# db_performance_test.sh

echo "🗄️ Database Performance Test"
echo "=========================="

# MySQL Performance Test
echo "\n📊 MySQL Performance:"
mysql -u root -p -e "
    SELECT 
        SCHEMA_NAME as 'Database',
        ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) as 'Size (MB)'
    FROM information_schema.SCHEMATA s
    LEFT JOIN information_schema.TABLES t ON s.SCHEMA_NAME = t.TABLE_SCHEMA
    GROUP BY SCHEMA_NAME;
    
    SHOW STATUS LIKE 'Slow_queries';
    SHOW STATUS LIKE 'Threads_connected';
    SHOW STATUS LIKE 'Innodb_buffer_pool_read_requests';
    SHOW STATUS LIKE 'Innodb_buffer_pool_reads';
"

# PostgreSQL Performance Test
echo "\n🐘 PostgreSQL Performance:"
psql -U postgres -d mydb -c "
    SELECT 
        schemaname,
        tablename,
        pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size,
        pg_stat_get_tuples_returned(c.oid) as tuples_returned,
        pg_stat_get_tuples_fetched(c.oid) as tuples_fetched
    FROM pg_tables pt
    JOIN pg_class c ON c.relname = pt.tablename
    WHERE schemaname = 'public'
    ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
    LIMIT 10;
    
    SELECT query, calls, total_time, mean_time 
    FROM pg_stat_statements 
    ORDER BY total_time DESC 
    LIMIT 10;
"

# Redis Performance Test
echo "\n🔴 Redis Performance:"
redis-cli --latency-history -h localhost -p 6379

echo "\n📈 Redis Info:"
redis-cli info memory
redis-cli info stats
```

#### Application Benchmarking
```bash
#!/bin/bash
# app_benchmark.sh

APP_URL=${1:-"http://localhost:3000"}
CONCURRENCY=${2:-10}
REQUESTS=${3:-1000}

echo "🚀 Application Benchmark"
echo "======================="
echo "URL: $APP_URL"
echo "Concurrency: $CONCURRENCY"
echo "Requests: $REQUESTS"
echo ""

# Apache Bench
echo "📊 Apache Bench Results:"
ab -n $REQUESTS -c $CONCURRENCY $APP_URL/api/posts

# curl performance test
echo "\n⏱️ Response Time Analysis:"
for i in {1..10}; do
    curl -w "@curl-format.txt" -o /dev/null -s $APP_URL/api/posts
done

# Siege test
echo "\n🏰 Siege Test Results:"
siege -c $CONCURRENCY -r $(($REQUESTS / $CONCURRENCY)) $APP_URL/api/posts

# Create curl format file
cat > curl-format.txt << 'EOF'
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
EOF
```

### 📊 Monitoring Scripts

#### System Resource Monitor
```bash
#!/bin/bash
# resource_monitor.sh

DURATION=${1:-60}
INTERVAL=${2:-5}

echo "🖥️ System Resource Monitor"
echo "========================"
echo "Duration: ${DURATION}s"
echo "Interval: ${INTERVAL}s"
echo ""

END_TIME=$(($(date +%s) + $DURATION))

while [ $(date +%s) -lt $END_TIME ]; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # CPU Usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    
    # Memory Usage
    MEMORY_INFO=$(free | grep Mem)
    MEMORY_TOTAL=$(echo $MEMORY_INFO | awk '{print $2}')
    MEMORY_USED=$(echo $MEMORY_INFO | awk '{print $3}')
    MEMORY_PERCENT=$(echo "scale=2; $MEMORY_USED * 100 / $MEMORY_TOTAL" | bc)
    
    # Disk Usage
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    # Network Stats
    NETWORK_IN=$(cat /proc/net/dev | grep eth0 | awk '{print $2}')
    NETWORK_OUT=$(cat /proc/net/dev | grep eth0 | awk '{print $10}')
    
    # Load Average
    LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }')
    
    echo "[$TIMESTAMP] CPU: ${CPU_USAGE}% | Memory: ${MEMORY_PERCENT}% | Disk: ${DISK_USAGE}% | Load:${LOAD_AVG}"
    
    sleep $INTERVAL
done

echo "\n✅ Monitoring completed"
```

#### Docker Performance Monitor
```bash
#!/bin/bash
# docker_monitor.sh

echo "🐳 Docker Performance Monitor"
echo "============================"

# Container resource usage
echo "\n📊 Container Resource Usage:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Container health check
echo "\n🏥 Container Health Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Docker system usage
echo "\n💾 Docker System Usage:"
docker system df

# Container logs errors
echo "\n🚨 Recent Container Errors:"
for container in $(docker ps --format "{{.Names}}"); do
    echo "\n--- $container ---"
    docker logs --tail 5 $container 2>&1 | grep -i "error\|exception\|fail" || echo "No recent errors"
done

# Network performance
echo "\n🌐 Network Performance:"
docker network ls
docker exec $(docker ps -q | head -1) ping -c 3 google.com 2>/dev/null || echo "Network test failed"
```

---

## 🎯 Performance Optimization Checklist

### ✅ Frontend Checklist
- [ ] **Images optimized** (WebP format, proper sizes, lazy loading)
- [ ] **CSS optimized** (critical CSS inline, non-critical async)
- [ ] **JavaScript optimized** (code splitting, tree shaking, minification)
- [ ] **Fonts optimized** (font-display: swap, preload critical fonts)
- [ ] **Bundle size analyzed** (webpack-bundle-analyzer)
- [ ] **Service Worker implemented** for caching
- [ ] **CDN configured** for static assets
- [ ] **Core Web Vitals** meet thresholds (LCP < 2.5s, FID < 100ms, CLS < 0.1)

### ✅ Backend Checklist
- [ ] **Database queries optimized** (indexes, no N+1 queries)
- [ ] **Caching implemented** (Redis, in-memory, HTTP headers)
- [ ] **Connection pooling** configured
- [ ] **Async operations** for I/O tasks
- [ ] **API pagination** implemented
- [ ] **Compression enabled** (gzip/brotli)
- [ ] **Load balancing** configured
- [ ] **Monitoring** and logging in place

### ✅ Database Checklist
- [ ] **Indexes optimized** (covering indexes, composite indexes)
- [ ] **Query analysis** performed (EXPLAIN plans)
- [ ] **Connection pooling** configured
- [ ] **Slow query logging** enabled
- [ ] **Database configuration** tuned for workload
- [ ] **Regular maintenance** scheduled (VACUUM, OPTIMIZE)
- [ ] **Replication** configured for read scaling
- [ ] **Backup strategy** optimized

### ✅ Infrastructure Checklist
- [ ] **Load balancer** configured
- [ ] **Auto-scaling** rules defined
- [ ] **CDN** configured
- [ ] **Monitoring** and alerting setup
- [ ] **Health checks** implemented
- [ ] **Resource limits** configured
- [ ] **Security hardening** applied
- [ ] **Disaster recovery** plan tested

---

## 🔚 Kết luận

Performance optimization là một quá trình liên tục và cần được theo dõi thường xuyên. Với toolkit này, bạn có thể:

- **Identify bottlenecks** nhanh chóng và chính xác
- **Optimize systematically** từng layer của ứng dụng
- **Monitor continuously** để đảm bảo hiệu suất ổn định
- **Scale efficiently** khi ứng dụng phát triển

**💡 Remember**: 
- Measure first, optimize second
- Focus on the biggest impact areas
- Monitor the results of your optimizations
- User experience should always be the priority

---

*⚡ Happy Optimizing! Remember: Premature optimization is the root of all evil, but well-planned optimization is the path to success.*
