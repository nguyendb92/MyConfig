# MyConfig - Fullstack Developer Environment Setup

## 📋 Tổng quan

Repository này chứa các script tự động hóa để thiết lập môi trường phát triển fullstack hoàn chỉnh trên Ubuntu, với hỗ trợ đặc biệt cho **WSL (Windows Subsystem for Linux)** và Ubuntu thuần:

- **Development Tools**: Git, Vim, VS Code, curl, wget, etc.
- **Frontend**: Node.js, npm, React, Vue, Angular CLI
- **Backend**: Python, Django, Flask, FastAPI
- **Database**: MySQL, PostgreSQL, Redis, SQLite
- **DevOps**: Docker, Docker Compose
- **Editor Config**: VS Code settings, extensions, Vim configuration
- **Shell**: Zsh với Oh My Zsh và custom aliases
- **WSL Support**: Cấu hình tối ưu cho môi trường WSL

## � Installation

### �🚀 Cài đặt tự động (Khuyến nghị)

#### Cài đặt hoàn chỉnh cho máy mới:

```bash
git clone https://github.com/nguyendb92/MyConfig.git
cd MyConfig
chmod +x auto_setup.sh
./auto_setup.sh
```

**Lưu ý**: Script sẽ tự động phát hiện môi trường WSL và cấu hình phù hợp.

#### Cấu hình nâng cao sau khi cài đặt:

##### Cho Ubuntu thuần:
```bash
make post-setup
```

##### Cho WSL (Windows Subsystem for Linux):
```bash
make wsl-setup
```

## 🎯 Usage

### Quản lý dịch vụ phát triển:

```bash
# Khởi động tất cả dịch vụ
make dev-start

# Dừng tất cả dịch vụ  
make dev-stop

# Kiểm tra trạng thái dịch vụ
make dev-status
```

### Cài đặt extensions VS Code:

```bash
make install-ext
```

### Tạo project mới nhanh:

```bash
# Tạo React project
make create-react

# Tạo Vue project
make create-vue

# Tạo Node.js project
make create-node

# Tạo Python project
make create-python
```

## 🛠️ Cài đặt thủ công

### Chỉ setup Vim:

```bash
git clone https://github.com/nguyendb92/MyConfig.git
cd MyConfig
chmod +x setup_vim.sh
./setup_vim.sh
```

Sau đó:
- Source config: `source ~/.vimrc`
- Cài đặt plugin: `:PlugInstall`
- Đặt colorscheme: `:colorscheme monokai`

### Copy VS Code settings:

```bash
cp vscode/settings.json ~/.config/Code/User/
cp vscode/keybindings.json ~/.config/Code/User/
```

### Setup aliases:

```bash
cp .aliases.zsh ~/
echo "source ~/.aliases.zsh" >> ~/.zshrc
source ~/.zshrc
```

## 📁 Cấu trúc thư mục

```
MyConfig/
├── auto_setup.sh              # Script tự động hóa chính
├── post_setup.sh              # Cấu hình bổ sung
├── install_extensions.sh      # Cài đặt VS Code extensions
├── setup_vim.sh               # Setup Vim
├── vimrc                      # Vim configuration
├── .aliases.zsh               # Custom aliases for Zsh
├── profile.code-profile       # VS Code profile
├── docs/                      # 📚 Tài liệu chi tiết
│   ├── index.md               # Index tài liệu tổng hợp
│   ├── VimCheatSheet.md       # Vim shortcuts & config
│   ├── FullstackDebugTechniques.md # Kỹ thuật debug toàn diện
│   ├── NamespaceDebugging.md  # Hệ thống namespace logging
│   └── ENHANCEMENTS.md        # Tính năng mới & cải tiến
├── vscode/
│   ├── settings.json          # VS Code settings
│   ├── keybindings.json       # VS Code keybindings
│   └── debug_django_example/  # Django debug example
└── README.md                  # Hướng dẫn này
```

## 🎯 Tính năng chính

### Auto Setup Script (`auto_setup.sh`)
- ✅ Cập nhật hệ thống và cài đặt development tools
- ✅ Cài đặt Node.js + npm packages (React, Vue, Angular CLI, etc.)
- ✅ Cài đặt Python + pip packages (Django, Flask, FastAPI, etc.)
- ✅ Cài đặt Docker & Docker Compose
- ✅ Cài đặt databases (MySQL, PostgreSQL, Redis)
- ✅ Cài đặt và cấu hình VS Code + extensions
- ✅ Setup Vim với plugins
- ✅ Cài đặt Zsh + Oh My Zsh + custom aliases
- ✅ Cài đặt additional tools (Postman, Chrome, Slack, etc.)
- ✅ Tạo cấu trúc thư mục development

### Post Setup Script (`post_setup.sh`)
- 🔧 Cấu hình MySQL với user development
- 🔧 Cấu hình PostgreSQL với database development
- 🔧 Setup Redis service
- 🔧 Tạo SSH key cho Git repositories
- 🔧 Tạo development scripts hữu ích

### Custom Aliases (`.aliases.zsh`)
- 🐳 **Docker**: `dps`, `dcu`, `dcd`, `dcb`, `dcl`, etc.
- 🗃️ **Database**: `mysql_login`, `pgstart`, `pgstop`, etc.
- 🔁 **Workflows**: `proj`, `gop`, `gom`, `rebuild`, etc.
- 🐍 **Python**: `venv`, `act`, `deact`, `pi`, `pir`, etc.
- 🌐 **Network**: `get`, `post`, `curltime`, `myip`, etc.

## 🎮 VS Code Configuration

### Vim Keybindings
```
Leader key: Space
jk: Exit insert mode
<leader>p: Command palette
<leader>sb: Toggle sidebar
Ctrl+hjkl: Navigate windows
```

### Extensions được cài đặt
- **Language Support**: Python, TypeScript, Tailwind CSS
- **Formatters**: Prettier, Black, ESLint
- **Git**: GitLens, GitLab Workflow
- **Docker**: Docker support, Remote containers
- **Database**: MySQL, PostgreSQL, Redis clients
- **AI**: GitHub Copilot, TabNine
- **Themes**: One Dark Pro, VS Code Icons

## 🛡️ Yêu cầu hệ thống

- **OS**: Ubuntu 20.04+ (hoặc Debian-based distributions)
- **RAM**: Tối thiểu 4GB (khuyến nghị 8GB+)
- **Storage**: Tối thiểu 10GB free space
- **Network**: Kết nối internet để download packages

## 📝 Ghi chú về Vim mappings

```vim
nnoremap – Map keys trong normal mode
inoremap – Map keys trong insert mode  
vnoremap – Map keys trong visual mode
```

### Vim Custom Keybindings
- `jk`: Exit insert mode
- `Space + n`: Focus NERDTree
- `Ctrl + n`: Open NERDTree
- `Ctrl + t`: Toggle NERDTree
- `H`: Move to beginning of line
- `L`: Move to end of line
- `J/K`: Move 5 lines down/up

####
Cach set speed key repeate on macos

```bash
defaults write -g KeyRepeat -int 1
defaults write -g IntialKeyRepeat -int 10
```

### Phần mềm trên windows (Recommended)
- [cgwin](https://www.cygwin.com/setup-x86_64.exe)
- [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/install)
- [VScode](https://code.visualstudio.com/Download)
- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Terraform](https://developer.hashicorp.com/terraform)
- [Portainer](https://github.com/portainer/portainer?tab=readme-ov-file)
- [Podmand](https://www.postman.com/downloads/)
- [MySQL workbench](https://dev.mysql.com/downloads/workbench/)
- [GitLab](https://git-scm.com/downloads/win)
- [Pgadmin4](https://www.pgadmin.org/download/)
- [Mongodb](https://www.mongodb.com/try/download/community)
- [MongoDB compass](https://www.mongodb.com/try/download/compass)

### Techstacks
- **Frontend Technologies:**
  - **Frameworks/Libraries**: React.js, Vue.js, Angular, Svelte, Next.js, Nuxt.js
  - **Styling**: Tailwind CSS, Bootstrap, Material-UI, Sass/SCSS, Styled Components
  - **Build Tools**: Webpack, Vite, Parcel, Rollup
  - **State Management**: Redux, Vuex, Pinia, Zustand, MobX

- **Backend Technologies:**
  - **Node.js**: Express.js, NestJS, Fastify, Koa.js
  - **Python**: Django, Flask, FastAPI, Pyramid
  - **Go**: Gin, Echo, Fiber

- **Databases:**
  - **Relational**: MySQL, PostgreSQL, MariaDB, SQLite
  - **NoSQL**: MongoDB, Redis, Cassandra, DynamoDB
  - **In-Memory**: Redis, Memcached
  - **Graph**: Neo4j, ArangoDB
  - **Time Series**: InfluxDB, TimescaleDB

- **DevOps & Cloud:**
  - **Containerization**: Docker, Kubernetes, Podman
  - **CI/CD**: GitHub Actions, GitLab CI, Jenkins, Travis CI
  - **Cloud Platforms**: AWS, Google Cloud, Azure, DigitalOcean
  - **Infrastructure**: Terraform, Ansible, CloudFormation
  - **Monitoring**: Prometheus, Grafana, ELK Stack

- **API & Communication:**
  - **REST APIs**: OpenAPI/Swagger, Postman
  - **GraphQL**: Apollo, Relay, Hasura
  - **Real-time**: WebSockets, Socket.io, Server-Sent Events
  - **Message Queues**: RabbitMQ, Apache Kafka, Redis Pub/Sub

- **Testing:**
  - **Frontend**: Jest, Cypress, Playwright, Testing Library
  - **Backend**: PyTest, JUnit, PHPUnit, Mocha, Chai
  - **API Testing**: Postman, Insomnia, Newman
  - **Load Testing**: Artillery, k6, JMeter

- **Version Control & Collaboration:**
  - **Git**: GitHub, GitLab, Bitbucket
  - **Package Managers**: npm, yarn, pip, composer, maven
  - **Documentation**: Markdown, Gitiles, Confluence

- **Security:**
  - **Authentication**: JWT, OAuth 2.0, Auth0, Firebase Auth
  - **HTTPS/SSL**: Let's Encrypt, Cloudflare
  - **Security Tools**: OWASP ZAP, Snyk, SonarQube
## � Tài liệu chi tiết

Xem thêm tài liệu chi tiết trong thư mục **[docs/](./docs/)**:

- **[📖 Vim Cheat Sheet](./docs/VimCheatSheet.md)** - Shortcuts và configuration chi tiết
- **[🐛 Debug Techniques](./docs/DebugTechniques.md)** - Kỹ thuật debug cho fullstack developer  
- **[⚡ Performance Optimization](./docs/PerformanceOptimization.md)** - Tối ưu hóa hiệu suất ứng dụng
- **[🔧 Troubleshooting Guide](./docs/TroubleshootingGuide.md)** - Xử lý sự cố thường gặp
- **[🆕 Enhancement Summary](./docs/ENHANCEMENTS.md)** - Tính năng mới và cải tiến WSL

## 📚 Documentation & Learning

### 🎓 Quick Start Guides
- **[📚 Docs Index](./docs/index.md)** - Tổng hợp tất cả tài liệu
- **[⚡ Vim Cheat Sheet](./docs/VimCheatSheet.md)** - Vim shortcuts và custom config

### 🐛 Advanced Debugging  
- **[🔧 Fullstack Debug Techniques](./docs/FullstackDebugTechniques.md)** - Kỹ thuật debug toàn diện
- **[🏷️ Namespace Debugging](./docs/NamespaceDebugging.md)** - Hệ thống log management với namespace

### 💡 Pro Tips
```bash
# Quick access to documentation
debug-help                    # Show all debug commands
list-namespaces              # Show available log namespaces  
find-logs AUTH               # Find authentication logs
remove-logs-dry TEMP         # Preview temp log cleanup
```
- **[⚡ Quick Reference](./docs/QuickReference.md)** - Tham khảo nhanh commands và shortcuts

## �🚨 Lưu ý quan trọng

1. **Backup dữ liệu**: Backup các config hiện có trước khi chạy script
2. **Restart terminal**: Sau khi cài đặt, restart terminal hoặc chạy `source ~/.zshrc`
3. **Docker group**: Log out và log in lại để Docker group có hiệu lực
4. **Database passwords**: Ghi nhớ passwords bạn đặt cho MySQL và PostgreSQL
5. **SSH key**: Copy SSH public key vào GitHub/GitLab accounts

## 🤝 Đóng góp

Nếu bạn có suggestions hoặc improvements, hãy tạo issue hoặc pull request!

## Buy Me a Coffee
- Tiếng Việt: "Yêu thích bài viết này? Hãy mời tôi một ly cà phê nhé!"
- Tiếng Anh: "Enjoyed this article? Buy me a coffee!"
 ![Tặng tác giả 1 cốc cà phê](./images/MaQR.jpg "Tặng tác giả một cốc cà phê")

## 📄 License
MIT License - Xem file docs/LICENSE để biết thêm chi tiết.
