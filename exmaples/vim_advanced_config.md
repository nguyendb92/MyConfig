# ⚡ Advanced VSCode Vim Configuration

> **Take your VSCode Vim setup to the next level with these optimizations**

---

## 🎯 Enhanced Settings.json

Add these to your existing `vscode/settings.json` for maximum power:

```jsonc
{
  // ============================================
  // 🔥 ESSENTIAL VIM SETTINGS
  // ============================================
  
  "vim.easymotion": true,
  "vim.hlsearch": true,
  "vim.incsearch": true,              // Incremental search
  "vim.useSystemClipboard": true,      // Share clipboard with OS
  "vim.useCtrlKeys": true,             // Enable <C-*> mappings
  "vim.leader": "<Space>",             // Space as leader (ergonomic!)
  "vim.foldfix": true,                 // Better folding
  
  // Sneak for quick navigation (2-char search)
  "vim.sneak": true,
  "vim.sneakUseIgnorecaseAndSmartcase": true,
  
  // Preserve cursor position
  "vim.startInInsertMode": false,
  "vim.visualstar": true,
  
  // Highlight yanked text briefly
  "vim.highlightedyank.enable": true,
  "vim.highlightedyank.color": "rgba(250, 240, 170, 0.5)",
  "vim.highlightedyank.duration": 200,
  
  // Smart case sensitivity
  "vim.ignorecase": true,
  "vim.smartcase": true,
  
  // Show command in status bar
  "vim.showcmd": true,
  
  // Timeout for key combinations
  "vim.timeout": 1000,
  "vim.timeoutlen": 500,
  
  // ============================================
  // 🎨 VISUAL FEEDBACK
  // ============================================
  
  "vim.statusBarColorControl": true,
  "vim.statusBarColors.normal": ["#8FBCBB", "#434C5E"],
  "vim.statusBarColors.insert": "#BF616A",
  "vim.statusBarColors.visual": "#B48EAD",
  "vim.statusBarColors.visualline": "#B48EAD",
  "vim.statusBarColors.visualblock": "#A3BE8C",
  "vim.statusBarColors.replace": "#D08770",
  
  "editor.lineNumbers": "relative",
  "editor.cursorBlinking": "solid",
  "editor.cursorSurroundingLines": 8,  // Keep cursor centered
  
  // ============================================
  // 🚫 DISABLE CONFLICTS
  // ============================================
  
  "vim.handleKeys": {
    "<C-a>": false,    // Select all
    "<C-f>": false,    // Find
    "<C-c>": false,    // Copy (use vim yank instead)
    "<C-v>": false,    // Paste in some contexts
    "<C-w>": false,    // Close tab (use <Space>cw)
    "<C-n>": false,    // New file
    "<C-p>": false,    // Command palette (use <Space>p)
    "<C-z>": false,    // Undo
    "<C-y>": false     // Redo
  },
  
  // ============================================
  // 📝 EDITOR ENHANCEMENTS
  // ============================================
  
  "editor.minimap.enabled": false,
  "editor.fontSize": 14,
  "editor.fontFamily": "'Fira Code', 'JetBrains Mono', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.lineHeight": 22,
  "editor.cursorStyle": "block",
  "editor.smoothScrolling": true,
  "editor.renderWhitespace": "selection",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  
  // Auto-save for safety
  "files.autoSave": "onFocusChange",
  
  // ============================================
  // 🎯 VIM KEYBINDINGS
  // ============================================
  
  "vim.insertModeKeyBindingsNonRecursive": [
    // Quick escape with jk
    {
      "before": ["j", "k"],
      "after": ["<ESC>"]
    },
    // Alternative escape with kj
    {
      "before": ["k", "j"],
      "after": ["<ESC>"]
    }
  ],
  
  "vim.normalModeKeyBindingsNonRecursive": [
    // ===== NAVIGATION =====
    
    // Enhanced line movement (5 lines at a time)
    {
      "before": ["J"],
      "after": ["5", "j"]
    },
    {
      "before": ["K"],
      "after": ["5", "k"]
    },
    
    // Line start/end (more ergonomic)
    {
      "before": ["H"],
      "after": ["^"]
    },
    {
      "before": ["L"],
      "after": ["g", "_"]
    },
    
    // Paragraph navigation
    {
      "before": ["{"],
      "after": ["{", "^"]
    },
    {
      "before": ["}"],
      "after": ["}", "^"]
    },
    
    // Split navigation (Ctrl + hjkl)
    {
      "before": ["<C-h>"],
      "after": ["<C-w>", "h"]
    },
    {
      "before": ["<C-j>"],
      "after": ["<C-w>", "j"]
    },
    {
      "before": ["<C-k>"],
      "after": ["<C-w>", "k"]
    },
    {
      "before": ["<C-l>"],
      "after": ["<C-w>", "l"]
    },
    
    // ===== LEADER KEY SHORTCUTS =====
    
    // Command & Files
    {
      "before": ["<leader>", "p"],
      "commands": ["workbench.action.showCommands"]
    },
    {
      "before": ["<leader>", "e"] 
      "commands": ["workbench.action.quickOpen"]
    },
    {
      "before": ["<leader>", "f", "f"],
      "commands": ["workbench.action.findInFiles"]
    },
    {
      "before": ["<leader>", "f", "r"],
      "commands": ["workbench.action.openRecent"]
    },
    
    // Window Management
    {
      "before": ["<leader>", "s", "b"],
      "commands": ["workbench.action.toggleSidebarVisibility"]
    },
    {
      "before": ["<leader>", "s", "h"],
      "commands": ["workbench.action.splitEditorLeft"]
    },
    {
      "before": ["<leader>", "s", "j"],
      "commands": ["workbench.action.splitEditorDown"]
    },
    {
      "before": ["<leader>", "s", "k"],
      "commands": ["workbench.action.splitEditorUp"]
    },
    {
      "before": ["<leader>", "s", "l"],
      "commands": ["workbench.action.splitEditorRight"]
    },
    
    // Tab Management
    {
      "before": ["<leader>", "t", "t"],
      "commands": ["workbench.action.files.newUntitledFile"]
    },
    {
      "before": ["<leader>", "t", "n"],
      "commands": ["workbench.action.nextEditor"]
    },
    {
      "before": ["<leader>", "t", "p"],
      "commands": ["workbench.action.previousEditor"]
    },
    {
      "before": ["<leader>", "t", "o"],
      "commands": ["workbench.action.closeOtherEditors"]
    },
    {
      "before": ["<leader>", "c", "w"],
      "commands": ["workbench.action.closeActiveEditor"]
    },
    {
      "before": ["<leader>", "c", "a"],
      "commands": ["workbench.action.closeAllEditors"]
    },
    {
      "before": ["<leader>", "c", "o"],
      "commands": ["workbench.action.closeEditorsInOtherGroups"]
    },
    
    // Focus & Zen
    {
      "before": ["<leader>", "z", "m"],
      "commands": ["workbench.action.toggleZenMode"]
    },
    {
      "before": ["<leader>", "z", "z"],
      "commands": ["workbench.action.toggleCenteredLayout"]
    },
    
    // Terminal
    {
      "before": ["<leader>", "`"],
      "commands": ["workbench.action.terminal.toggleTerminal"]
    },
    {
      "before": ["<leader>", "t", "m"],
      "commands": ["workbench.action.terminal.new"]
    },
    
    // Git
    {
      "before": ["<leader>", "g", "s"],
      "commands": ["workbench.view.scm"]
    },
    {
      "before": ["<leader>", "g", "d"],
      "commands": ["git.openChange"]
    },
    {
      "before": ["<leader>", "g", "b"],
      "commands": ["gitlens.toggleFileBlame"]
    },
    {
      "before": ["<leader>", "g", "h"],
      "commands": ["gitlens.showQuickFileHistory"]
    },
    
    // Code Navigation
    {
      "before": ["g", "d"],
      "commands": ["editor.action.revealDefinition"]
    },
    {
      "before": ["g", "D"],
      "commands": ["editor.action.revealDefinitionAside"]
    },
    {
      "before": ["g", "r"],
      "commands": ["editor.action.goToReferences"]
    },
    {
      "before": ["g", "i"],
      "commands": ["editor.action.goToImplementation"]
    },
    {
      "before": ["g", "h"],
      "commands": ["editor.action.showHover"]
    },
    {
      "before": ["g", "t"],
      "commands": ["editor.action.goToTypeDefinition"]
    },
    
    // Refactoring
    {
      "before": ["<leader>", "r", "r"],
      "commands": ["editor.action.rename"]
    },
    {
      "before": ["<leader>", "r", "f"],
      "commands": ["editor.action.formatDocument"]
    },
    {
      "before": ["<leader>", "r", "s"],
      "commands": ["editor.action.formatSelection"]
    },
    {
      "before": ["<leader>", "r", "a"],
      "commands": ["editor.action.quickFix"]
    },
    {
      "before": ["<leader>", "r", "o"],
      "commands": ["editor.action.organizeImports"]
    },
    
    // Code Folding
    {
      "before": ["<leader>", "f", "o"],
      "commands": ["editor.unfoldAll"]
    },
    {
      "before": ["<leader>", "f", "c"],
      "commands": ["editor.foldAll"]
    },
    {
      "before": ["<leader>", "f", "1"],
      "commands": ["editor.foldLevel1"]
    },
    {
      "before": ["<leader>", "f", "2"],
      "commands": ["editor.foldLevel2"]
    },
    
    // Debugging
    {
      "before": ["<leader>", "d", "b"],
      "commands": ["editor.debug.action.toggleBreakpoint"]
    },
    {
      "before": ["<leader>", "d", "c"],
      "commands": ["workbench.action.debug.continue"]
    },
    {
      "before": ["<leader>", "d", "s"],
      "commands": ["workbench.action.debug.start"]
    },
    {
      "before": ["<leader>", "d", "o"],
      "commands": ["workbench.action.debug.stepOver"]
    },
    {
      "before": ["<leader>", "d", "i"],
      "commands": ["workbench.action.debug.stepInto"]
    },
    {
      "before": ["<leader>", "d", "u"],
      "commands": ["workbench.action.debug.stepOut"]
    },
    
    // Search
    {
      "before": ["<leader>", "/"],
      "commands": [":noh"]
    },
    {
      "before": ["<leader>", "s", "s"],
      "commands": ["workbench.action.gotoSymbol"]
    },
    {
      "before": ["<leader>", "s", "w"],
      "commands": ["workbench.action.showAllSymbols"]
    },
    
    // Quick Actions
    {
      "before": ["<leader>", "w"],
      "commands": ["workbench.action.files.save"]
    },
    {
      "before": ["<leader>", "W"],
      "commands": ["workbench.action.files.saveAll"]
    },
    {
      "before": ["<leader>", "q"],
      "commands": ["workbench.action.closeActiveEditor"]
    },
    {
      "before": ["<leader>", "Q"],
      "commands": ["workbench.action.closeWindow"]
    },
    
    // ===== SMART LINE OPERATIONS =====
    
    // Insert line and stay in normal mode
    {
      "before": ["o"],
      "after": ["o", "<ESC>"]
    },
    {
      "before": ["O"],
      "after": ["O", "<ESC>"]
    },
    
    // Visual mode with mark
    {
      "before": ["v"],
      "after": ["m", "y", "v"]
    },
    {
      "before": ["V"],
      "after": ["m", "y", "V"]
    },
    
    // Better mark usage
    {
      "before": ["'"],
      "after": ["`"]
    },
    
    // Undo/Redo
    {
      "before": ["u"],
      "commands": ["undo"]
    },
    {
      "before": ["<C-r>"],
      "commands": ["redo"]
    },
    
    // ===== WINDOW RESIZE =====
    {
      "before": ["<C-Up>"],
      "commands": ["workbench.action.increaseViewHeight"]
    },
    {
      "before": ["<C-Down>"],
      "commands": ["workbench.action.decreaseViewHeight"]
    },
    {
      "before": ["<C-Left>"],
      "commands": ["workbench.action.decreaseViewWidth"]
    },
    {
      "before": ["<C-Right>"],
      "commands": ["workbench.action.increaseViewWidth"]
    }
  ],
  
  "vim.visualModeKeyBindingsNonRecursive": [
    // Better copy that returns to position
    {
      "before": ["g", "y"],
      "after": ["y", "`", "y"]
    },
    
    // Paste without overwriting register
    {
      "before": ["p"],
      "after": ["p", "g", "v", "y"]
    },
    
    // Indent and reselect
    {
      "before": [">"],
      "after": [">", "g", "v"]
    },
    {
      "before": ["<"],
      "after": ["<", "g", "v"]
    },
    
    // Move lines up/down
    {
      "before": ["J"],
      "commands": ["editor.action.moveLinesDownAction"]
    },
    {
      "before": ["K"],
      "commands": ["editor.action.moveLinesUpAction"]
    }
  ],
  
  "vim.operatorPendingModeKeyBindings": [
    // Search in line (like f but for multiple chars)
    {
      "before": ["/"],
      "after": ["f"]
    }
  ]
}
```

---

## 🚀 Advanced Keybindings.json

Add these to your `vscode/keybindings.json`:

```jsonc
[
  // ============================================
  // 🎯 VIM-FRIENDLY KEYBINDINGS
  // ============================================
  
  // Explorer (Vim motions in file explorer)
  {
    "key": "j",
    "command": "list.focusDown",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "k",
    "command": "list.focusUp",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "h",
    "command": "list.collapse",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "l",
    "command": "list.expand",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "o",
    "command": "list.select",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "a",
    "command": "explorer.newFile",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "shift+a",
    "command": "explorer.newFolder",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "r",
    "command": "renameFile",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "d",
    "command": "deleteFile",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "y",
    "command": "filesExplorer.copy",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "p",
    "command": "filesExplorer.paste",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  {
    "key": "x",
    "command": "filesExplorer.cut",
    "when": "explorerViewletVisible && filesExplorerFocus && !inputFocus"
  },
  
  // Suggestions (Vim motions in autocomplete)
  {
    "key": "ctrl+j",
    "command": "selectNextSuggestion",
    "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
  },
  {
    "key": "ctrl+k",
    "command": "selectPrevSuggestion",
    "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
  },
  {
    "key": "ctrl+l",
    "command": "acceptSelectedSuggestion",
    "when": "suggestWidgetVisible && textInputFocus"
  },
  
  // Quick Open (Ctrl+P)
  {
    "key": "ctrl+j",
    "command": "workbench.action.quickOpenSelectNext",
    "when": "inQuickOpen"
  },
  {
    "key": "ctrl+k",
    "command": "workbench.action.quickOpenSelectPrevious",
    "when": "inQuickOpen"
  },
  
  // Search results
  {
    "key": "ctrl+j",
    "command": "search.action.focusNextSearchResult",
    "when": "hasSearchResult || inSearchEditor"
  },
  {
    "key": "ctrl+k",
    "command": "search.action.focusPreviousSearchResult",
    "when": "hasSearchResult || inSearchEditor"
  },
  
  // Terminal
  {
    "key": "ctrl+j",
    "command": "workbench.action.terminal.focusNext",
    "when": "terminalFocus"
  },
  {
    "key": "ctrl+k",
    "command": "workbench.action.terminal.focusPrevious",
    "when": "terminalFocus"
  },
  
  // Better tab navigation
  {
    "key": "alt+h",
    "command": "workbench.action.previousEditor"
  },
  {
    "key": "alt+l",
    "command": "workbench.action.nextEditor"
  },
  
  // Move editor to other group
  {
    "key": "alt+shift+h",
    "command": "workbench.action.moveEditorToLeftGroup"
  },
  {
    "key": "alt+shift+j",
    "command": "workbench.action.moveEditorToBelowGroup"
  },
  {
    "key": "alt+shift+k",
    "command": "workbench.action.moveEditorToAboveGroup"
  },
  {
    "key": "alt+shift+l",
    "command": "workbench.action.moveEditorToRightGroup"
  },
  
  // Maximize editor
  {
    "key": "alt+m",
    "command": "workbench.action.toggleMaximizeEditorGroup"
  },
  
  // Panel navigation
  {
    "key": "alt+1",
    "command": "workbench.view.explorer"
  },
  {
    "key": "alt+2",
    "command": "workbench.view.search"
  },
  {
    "key": "alt+3",
    "command": "workbench.view.scm"
  },
  {
    "key": "alt+4",
    "command": "workbench.view.debug"
  },
  {
    "key": "alt+5",
    "command": "workbench.view.extensions"
  }
]
```

---

## 🎨 Additional VSCode Settings

```jsonc
{
  // ============================================
  // 🎯 PERFORMANCE
  // ============================================
  
  "files.exclude": {
    "**/.git": true,
    "**/.svn": true,
    "**/.hg": true,
    "**/CVS": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.pytest_cache": true,
    "**/*.pyc": true
  },
  
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/*.code-search": true,
    "**/dist": true,
    "**/build": true,
    "**/.venv": true,
    "**/.git": true
  },
  
  // ============================================
  // 💻 TERMINAL
  // ============================================
  
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontWeight": "normal",
  "terminal.integrated.cursorStyle": "block",
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.scrollback": 10000,
  "terminal.integrated.enableMultiLinePasteWarning": false,
  
  // ============================================
  // 🎨 APPEARANCE
  // ============================================
  
  "workbench.colorTheme": "One Dark Pro Darker",
  "workbench.iconTheme": "vscode-icons",
  "workbench.activityBar.location": "top",  // More screen space
  "workbench.editor.enablePreview": false,   // Always open files in new tab
  "workbench.editor.closeEmptyGroups": false,
  "workbench.startupEditor": "newUntitledFile",
  "window.zoomLevel": 0,
  
  // ============================================
  // 📝 EDITOR BEHAVIOR
  // ============================================
  
  "editor.formatOnSave": true,
  "editor.formatOnPaste": false,
  "editor.formatOnType": false,
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": false
  },
  "editor.suggest.insertMode": "replace",
  "editor.acceptSuggestionOnEnter": "on",
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.detectIndentation": true,
  "editor.wordWrap": "off",
  "editor.rulers": [80, 120],
  "editor.renderLineHighlight": "all",
  
  // ============================================
  // 🔍 SEARCH
  // ============================================
  
  "search.smartCase": true,
  "search.useIgnoreFiles": true,
  "search.showLineNumbers": true,
  
  // ============================================
  // 🐛 DEBUG
  // ============================================
  
  "debug.console.fontSize": 14,
  "debug.internalConsoleOptions": "neverOpen",
  "debug.openDebug": "openOnDebugBreak",
  
  // ============================================
  // 📦 EXTENSIONS
  // ============================================
  
  // GitLens
  "gitlens.currentLine.enabled": false,
  "gitlens.hovers.currentLine.over": "line",
  "gitlens.codeLens.enabled": false,
  
  // Bracket Pair Colorizer (built-in now)
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  
  // File Icons
  "vsicons.dontShowNewVersionMessage": true,
  
  // Auto Rename Tag
  "auto-rename-tag.activationOnLanguage": [
    "html",
    "xml",
    "php",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ]
}
```

---

## 🔌 Recommended Extensions

Install these for maximum Vim power:

```bash
# Core Vim
code --install-extension vscodevim.vim

# Sneak for quick navigation
# (Built into VSCodeVim, just enable in settings)

# Enhanced Git
code --install-extension eamodio.gitlens
code --install-extension mhutchie.git-graph

# Code Navigation
code --install-extension ms-vscode.references-view
code --install-extension usernamehw.errorlens

# Visual Improvements
code --install-extension oderwat.indent-rainbow
code --install-extension vscode-icons-team.vscode-icons
code --install-extension formulahendry.auto-rename-tag
code --install-extension CoenraadS.bracket-pair-colorizer-2  # Now built-in

# Language Support
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-typescript-next

# Productivity
code --install-extension shardulm94.trailing-spaces
code --install-extension christian-kohler.path-intellisense
code --install-extension formulahendry.code-runner
```

---

## 🎯 Vim Training Script

Create a training script to build muscle memory:

```bash
#!/bin/bash
# Save as ~/vim-training.sh

echo "🏋️ Vim Daily Training - 5 minutes"
echo "=================================="
echo ""

echo "1. Basic Navigation (1 min)"
echo "   - Navigate using only hjkl, wbe"
echo "   - Jump with {}, gg, G"
echo ""
read -p "Press Enter when done..."

echo "2. Text Objects (1 min)"
echo "   - ciw, ci\", ci(, ci{"
echo "   - diw, di\", di(, di{"
echo ""
read -p "Press Enter when done..."

echo "3. Search & Jump (1 min)"
echo "   - * → n → n → cgn → new → . . ."
echo "   - fa → ; → ; → ;"
echo ""
read -p "Press Enter when done..."

echo "4. Visual Mode (1 min)"
echo "   - V → select → d/c/y/>"
echo "   - <C-v> → select → I → // → <ESC>"
echo ""
read -p "Press Enter when done..."

echo "5. Repeat & Macro (1 min)"
echo "   - ciw → text → <ESC> → . . ."
echo "   - qa → commands → q → @a @a"
echo ""
read -p "Press Enter when done..."

echo ""
echo "✅ Training complete! You're getting better!"
```

Make it executable and run daily:
```bash
chmod +x ~/vim-training.sh
alias vtrain='~/vim-training.sh'
```

---

## 💡 Pro Tips

### 1. Speed Optimization
- Keep hands on home row (asdf jkl;)
- Use `jk` instead of ESC (saves pinky strain)
- Use `H` and `L` instead of `0` and `$`
- Use `J` and `K` for 5-line jumps

### 2. Consistency Tips
- Always exit insert mode immediately after typing
- Think in text objects, not character movements
- Use `.` command for repetitive tasks
- Set marks before jumping around

### 3. Common Patterns
```vim
" Rename variable
* → cgn → new_name → . . . .

" Comment multiple lines
<C-v> → select → I → // → <ESC>

" Format function
vi{ → =

" Delete function arguments
di( → i → new_args

" Wrap in quotes
ciw → "Ctrl+r"" → <ESC>
```

### 4. Debugging Workflow
```vim
<Space>db    → Toggle breakpoint
<Space>ds    → Start debugging
<Space>dc    → Continue
<Space>do    → Step over
<Space>di    → Step into
<Space>du    → Step out
```

### 5. Git Workflow
```vim
<Space>gs    → Git status
<Space>gd    → View diff
<Space>gb    → Toggle blame
<Space>gh    → File history
```

---

## 🎓 Learning Path

### Week 1-2: Foundation
- ✅ Basic navigation (hjkl, wbe, HLJ K)
- ✅ Text objects (ciw, ci", ci()
- ✅ Insert mode escape (jk)
- ✅ Copy/paste (yy, p)

### Week 3-4: Intermediate
- ✅ Visual modes (v, V, <C-v>)
- ✅ Search & replace (*, /, cgn, .)
- ✅ Leader shortcuts (<Space> combos)
- ✅ Split navigation (<C-hjkl>)

### Week 5-6: Advanced
- ✅ Macros (qa, @a, @@)
- ✅ Marks (ma, `a, '')
- ✅ Registers ("a, "b, "0)
- ✅ EasyMotion (,,w, ,,f)

### Week 7-8: Mastery
- ✅ Code navigation (gd, gr, gi)
- ✅ Refactoring (<Space>r*)
- ✅ Custom workflows
- ✅ Teach others!

---

## 📊 Success Metrics

Track your progress:

| Week | Task Time | Errors | Mouse Usage | Shortcuts Used |
|------|-----------|--------|-------------|----------------|
| 1    |           |        |             |                |
| 2    |           |        |             |                |
| 4    |           |        |             |                |
| 8    |           |        |             |                |

**Goals:**
- 50% reduction in task time by week 4
- 0 mouse usage by week 6
- 80%+ shortcuts usage by week 8
- Teach colleague by week 10

---

## 🔗 Resources

- **VSCodeVim GitHub**: https://github.com/VSCodeVim/Vim
- **Vim Cheat Sheet**: https://vim.rtorr.com/
- **Vim Adventures**: https://vim-adventures.com/
- **Vim Golf**: https://www.vimgolf.com/
- **r/vim**: https://reddit.com/r/vim

---

**Now you're ready to become a Vim master! 🚀**

*Remember: Consistency beats intensity. Practice 10 minutes daily!*
