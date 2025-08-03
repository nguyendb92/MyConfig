# MyConfig Documentation Index

## 📚 Tài liệu hướng dẫn tổng hợp

Thư mục này chứa tất cả tài liệu hướng dẫn và cheat sheets cho MyConfig fullstack development environment.

## 📋 Danh sách tài liệu

### 🐛 Debugging & Development
- **[FullstackDebugTechniques.md](./FullstackDebugTechniques.md)** - Kỹ thuật debug toàn diện cho fullstack developers
- **[NamespaceDebugging.md](./NamespaceDebugging.md)** - Hệ thống namespace logging và quản lý debug logs

### ⚡ Tools & Shortcuts  
- **[VimCheatSheet.md](./VimCheatSheet.md)** - Vim shortcuts và custom configurations
- **[AliasesGuide.md](./AliasesGuide.md)** - Hướng dẫn sử dụng custom aliases và functions *(Coming soon)*

### 🚀 Setup & Configuration
- **[WSLSetupGuide.md](./WSLSetupGuide.md)** - Hướng dẫn setup WSL environment *(Coming soon)*
- **[DevelopmentWorkflow.md](./DevelopmentWorkflow.md)** - Quy trình development với MyConfig *(Coming soon)*

### 🔧 Advanced Topics
- **[DockerIntegration.md](./DockerIntegration.md)** - Docker workflows và debugging *(Coming soon)*
- **[DatabaseManagement.md](./DatabaseManagement.md)** - Database setup và management *(Coming soon)*

## 🎯 Quick Navigation

### Cho người mới bắt đầu
1. Đọc [README.md](../README.md) để hiểu overview
2. Chạy setup script: `./auto_setup.sh`
3. Học các shortcut cơ bản trong [VimCheatSheet.md](./VimCheatSheet.md)
4. Áp dụng namespace debugging từ [NamespaceDebugging.md](./NamespaceDebugging.md)

### Cho advanced users
1. Nghiên cứu [FullstackDebugTechniques.md](./FullstackDebugTechniques.md) để nâng cao kỹ năng debug
2. Customize thêm aliases theo nhu cầu
3. Contribute back các improvements

## 🛠️ Cách sử dụng tài liệu

### Namespace Debugging Workflow
```bash
# 1. Thêm namespace logs vào code
log.auth.debug('User login attempt', { email });

# 2. Development và testing
# ...

# 3. Trước khi commit, clean up logs
remove-logs-dry AUTH    # Preview
remove-logs AUTH        # Clean up
```

### Vim Workflow  
```bash
# 1. Mở file với vim
vim myfile.js

# 2. Sử dụng custom shortcuts
Space + n               # NERDTree
jk                      # Exit insert mode
Space + p               # Command palette (VS Code)
```

## 📖 Documentation Standards

### Format Conventions
- **Headers**: Sử dụng emojis để dễ nhận diện
- **Code blocks**: Luôn specify language
- **Examples**: Bao gồm practical examples
- **Navigation**: Table of contents cho files dài

### File Naming
- `PascalCase.md` cho tài liệu chính
- `kebab-case.md` cho guides nhỏ
- Prefix theo category (debug-, setup-, vim-, etc.)

## 🤝 Contributing

### Thêm tài liệu mới
1. Tạo file trong thư mục `/docs`
2. Follow formatting standards
3. Cập nhật file này (`index.md`)
4. Add examples và practical use cases

### Cập nhật tài liệu hiện có
1. Maintain consistency với existing format
2. Add new sections nếu cần
3. Update relevant cross-references

## 🔗 External Resources

### Learning Resources
- [Vim Documentation](https://vimdoc.sourceforge.net/)
- [Docker Documentation](https://docs.docker.com/)
- [Node.js Debugging Guide](https://nodejs.org/en/docs/guides/debugging-getting-started/)
- [React DevTools](https://react.dev/learn/react-developer-tools)

### Tools Integration
- **VS Code Settings**: `vscode/settings.json`
- **Vim Config**: `vimrc`
- **Aliases**: `.aliases.zsh`
- **Scripts**: `auto_setup.sh`, `post_setup.sh`

---

💡 **Tip**: Bookmark page này để nhanh chóng access tất cả documentation khi cần!
