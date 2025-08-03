# 🎯 Vim Cheat Sheet - MyConfig Edition

> **Based on your personal Vim configuration** (`vimrc`) and VS Code Vim settings  
> **Leader Key**: `Space` (` `)  
> **Theme**: Monokai  
> **Quick Exit**: `jk` (in insert mode)

## 📋 Mục lục
- [Basic Navigation](#-basic-navigation)
- [Custom Key Mappings](#-custom-key-mappings)
- [NERDTree Navigation](#-nerdtree-navigation)
- [Window Management](#-window-management)
- [Search & Replace](#-search--replace)
- [VS Code Vim Integration](#-vs-code-vim-integration)
- [Plugin Commands](#-plugin-commands)
- [Debug Namespace Logging](#-debug-namespace-logging)
- [Useful Tips](#-useful-tips)

---

## 🧭 Basic Navigation

### Movement Commands
```vim
# Basic Movement
h, j, k, l           # Left, Down, Up, Right
w, b                 # Word forward, word backward
e                    # End of word
0, $                 # Beginning/end of line
gg, G                # First/last line of file

# Custom Mappings (from your config)
H                    # ^ (beginning of line) - mapped in your vimrc
L                    # g_ (end of line without newline) - mapped in your vimrc
J                    # 5j (move 5 lines down) - mapped in your vimrc
K                    # 5k (move 5 lines up) - mapped in your vimrc
```

### Jump Commands
```vim
Ctrl + f             # Page down
Ctrl + b             # Page up
Ctrl + d             # Half page down
Ctrl + u             # Half page up
'                    # ` (go to mark) - mapped in your vimrc
```

---

## ⌨️ Custom Key Mappings

### Leader Key Actions
**Leader Key: `Space`** (configured as `let mapleader = " "`)

```vim
<Space>n             # :NERDTreeFocus - Focus on NERDTree
<Space>p             # Command Palette (VS Code only)
<Space>sb            # Toggle Sidebar (VS Code only)
```

### Insert Mode
```vim
jk                   # <Esc> - Exit insert mode (custom mapping)
```

### Normal Mode Actions
```vim
o                    # o<Esc> - Create new line below and stay in normal mode
O                    # O<Esc> - Create new line above and stay in normal mode
```

---

## 🌳 NERDTree Navigation

### Opening/Closing NERDTree
```vim
Ctrl + n             # :NERDTree - Open NERDTree
Ctrl + t             # :NERDTreeToggle - Toggle NERDTree
Ctrl + f             # :NERDTreeFind - Find current file in NERDTree
F3                   # :NERDTreeToggle - Alternative toggle
<Space>n             # :NERDTreeFocus - Focus on NERDTree window
```

### Inside NERDTree
```vim
Enter                # Open file/expand directory
o                    # Open file in previous window
i                    # Open file in horizontal split
s                    # Open file in vertical split
t                    # Open file in new tab
T                    # Open file in new tab silently
p                    # Go to parent directory
P                    # Go to root directory
r                    # Refresh current directory
R                    # Refresh root directory
m                    # Show menu (create, delete, rename files)
q                    # Close NERDTree
?                    # Toggle help
```

---

## 🪟 Window Management

### Split Windows
```vim
:split               # Horizontal split
:vsplit              # Vertical split
:sp <filename>       # Open file in horizontal split
:vsp <filename>      # Open file in vertical split
```

### Navigate Between Windows
```vim
Ctrl + j             # Move to window below (custom mapping)
Ctrl + k             # Move to window above (custom mapping)
Ctrl + h             # Move to window left (custom mapping)
Ctrl + l             # Move to window right (custom mapping)
```

### Resize Windows
```vim
Ctrl + Up            # Increase window height (custom mapping)
Ctrl + Down          # Decrease window height (custom mapping)
Ctrl + Left          # Increase window width (custom mapping)
Ctrl + Right         # Decrease window width (custom mapping)
```

---

## 🔍 Search & Replace

### Search Configuration (from your vimrc)
```vim
# Search settings active in your config:
set hls              # Highlight search results
set incsearch        # Incremental search
set ignorecase       # Case insensitive search
```

### Search Commands
```vim
/pattern             # Search forward
?pattern             # Search backward
n                    # Next match
N                    # Previous match
*                    # Search word under cursor forward
#                    # Search word under cursor backward
:noh                 # Clear search highlighting
```

### Replace Commands
```vim
:s/old/new/          # Replace first occurrence in current line
:s/old/new/g         # Replace all occurrences in current line
:%s/old/new/g        # Replace all occurrences in file
:%s/old/new/gc       # Replace all with confirmation
```

---

## 💻 VS Code Vim Integration

### VS Code Specific Commands (from your settings.json)
```vim
<Space>p             # workbench.action.showCommands (Command Palette)
<Space>sb            # workbench.action.toggleSidebarVisibility
jk                   # <ESC> (in insert mode)
```

### Visual Mode (VS Code)
```vim
gy                   # y`y - Special yank command (from your config)
```

### Status Bar Colors (configured in your VS Code settings)
- **Normal mode**: Light blue (`#8FBCBB`)
- **Insert mode**: Red (`#BF616A`)
- **Visual mode**: Purple (`#B48EAD`)
- **Replace mode**: Orange (`#D08770`)

---

## 🔌 Plugin Commands

### EasyMotion (installed in your config)
```vim
<leader><leader>w    # Jump to word
<leader><leader>f    # Find character
<leader><leader>j    # Jump to line below
<leader><leader>k    # Jump to line above
```

### Emmet (installed in your config)
```vim
<C-y>,              # Expand Emmet abbreviation
```

### Vim-airline (installed in your config)
- Shows file info in status line
- Displays current mode
- Shows file encoding and type

---

## 🐛 Debug Namespace Logging

### Quick Debug Aliases (add to your workflow)
```vim
# Use these patterns in your code, then clean up with aliases:

# JavaScript/TypeScript
console.log('[API-DEBUG] User data:', userData);
console.log('[UI-DEBUG] Button clicked:', buttonId);
console.log('[TEMP-DEBUG] Quick debug:', value);

# Then use aliases from terminal:
# debug-dry TEMP-DEBUG        (preview removal)
# debug-clean TEMP-DEBUG      (remove logs)
# clean-temp-logs             (interactive cleanup)
```

---

## 💡 Useful Tips

### Configuration Settings (active in your vimrc)
```vim
set number           # Show line numbers
set shiftwidth=4     # 4 spaces for indentation
set tabstop=4        # 4 spaces for tabs
set expandtab        # Use spaces instead of tabs
set nobackup         # Don't create backup files
set scrolloff=10     # Keep 10 lines visible when scrolling
set nowrap           # Don't wrap lines
set autoindent       # Auto indentation
set smartindent      # Smart indentation
```

### Quick File Operations
```vim
:w                   # Save file
:q                   # Quit
:wq                  # Save and quit
:q!                  # Quit without saving
:e <filename>        # Edit file
:bn                  # Next buffer
:bp                  # Previous buffer
```

### Text Manipulation
```vim
yy                   # Yank (copy) line
dd                   # Delete line
p                    # Paste below
P                    # Paste above
u                    # Undo
Ctrl + r             # Redo
.                    # Repeat last command
```

### Marks and Jumps
```vim
ma                   # Set mark 'a'
'a                   # Jump to mark 'a' (custom: uses ` instead of ')
Ctrl + o             # Jump to previous location
Ctrl + i             # Jump to next location
```

---

## 🚀 Pro Tips for Your Setup

1. **Use `jk` instead of Escape** - Much faster for exiting insert mode
2. **Leader + n for quick NERDTree access** - Your custom mapping for file navigation
3. **Use H and L for line boundaries** - Faster than 0 and $
4. **J and K for faster vertical movement** - 5 lines at a time
5. **Window navigation with Ctrl+hjkl** - Seamless window switching
6. **F3 for quick NERDTree toggle** - One-key file tree access
7. **Use namespace debug logging** - Clean up easily with your custom aliases

---

## 📚 Plugin Installation Commands

Since you're using vim-plug, remember these commands:
```vim
:PlugInstall         # Install plugins
:PlugUpdate          # Update plugins
:PlugClean           # Remove unused plugins
:PlugStatus          # Check plugin status
```

---

*🎯 Happy Vimming! Your configuration is optimized for productivity and speed.*  
- **Tab Width**: 4 spaces
- **Auto Indent**: Smart indentation enabled
- **Search**: Incremental, case-insensitive (smart case)
- **History**: 1000 commands

---

## 🚀 Essential Custom Keybindings

### ⌨️ Mode Switching
| Command | Action | Description |
|---------|--------|-------------|
| `jk` | `<Esc>` | Exit insert mode (custom mapping) |
| `i` | Insert mode | Start inserting before cursor |
| `a` | Insert mode | Start inserting after cursor |
| `v` | Visual mode | Start visual selection |

### 🎯 Navigation (Custom Enhanced)
| Command | Action | Description |
|---------|--------|-------------|
| `H` | `^` | Move to **first non-blank** character of line |
| `L` | `g_` | Move to **last non-blank** character of line |
| `J` | `5j` | Move **5 lines down** (fast) |
| `K` | `5k` | Move **5 lines up** (fast) |
| `'` | `` ` `` | Jump to exact mark position |

### 🪟 Window Management
| Command | Action | Description |
|---------|--------|-------------|
| `Ctrl+h` | `<C-w>h` | Move to **left** window |
| `Ctrl+j` | `<C-w>j` | Move to **bottom** window |
| `Ctrl+k` | `<C-w>k` | Move to **top** window |
| `Ctrl+l` | `<C-w>l` | Move to **right** window |

### 📏 Window Resizing
| Command | Action | Description |
|---------|--------|-------------|
| `Ctrl+↑` | `<C-w>+` | Increase window height |
| `Ctrl+↓` | `<C-w>-` | Decrease window height |
| `Ctrl+←` | `<C-w>>` | Increase window width |
| `Ctrl+→` | `<C-w><` | Decrease window width |

### 📝 Custom Line Operations
| Command | Action | Description |
|---------|--------|-------------|
| `o` | `o<Esc>` | Insert new line below (stay in normal mode) |
| `O` | `O<Esc>` | Insert new line above (stay in normal mode) |

---

## 🌳 NERDTree File Explorer

### Basic NERDTree Commands
| Command | Action | Description |
|---------|--------|-------------|
| `Space+n` | `:NERDTreeFocus` | **Focus** on NERDTree window |
| `Ctrl+n` | `:NERDTree` | **Open** NERDTree |
| `Ctrl+t` | `:NERDTreeToggle` | **Toggle** NERDTree on/off |
| `Ctrl+f` | `:NERDTreeFind` | **Find** current file in NERDTree |
| `F3` | `:NERDTreeToggle` | **Toggle** NERDTree (alternative) |

### NERDTree Navigation (in NERDTree window)
| Command | Action | Description |
|---------|--------|-------------|
| `j/k` | Move up/down | Navigate through files |
| `Enter` | Open file | Open selected file |
| `o` | Open file | Open selected file (alternative) |
| `t` | Open in new tab | Open file in new tab |
| `s` | Split vertical | Open file in vertical split |
| `i` | Split horizontal | Open file in horizontal split |
| `p` | Go to parent | Move to parent directory |
| `P` | Go to root | Move to root directory |
| `r` | Refresh | Refresh current directory |
| `R` | Refresh root | Refresh root directory |
| `m` | Menu | Show NERDTree menu (create, delete, etc.) |
| `?` | Help | Show NERDTree help |

---

## 🔍 Search & Replace

### Search Commands
| Command | Action | Description |
|---------|--------|-------------|
| `/pattern` | Search forward | Search for pattern (case-insensitive*) |
| `?pattern` | Search backward | Search backward for pattern |
| `n` | Next match | Go to next search result |
| `N` | Previous match | Go to previous search result |
| `:noh` | Clear highlight | Remove search highlighting |

*Smart case: lowercase = case-insensitive, mixed case = case-sensitive

### Replace Commands
| Command | Action | Description |
|---------|--------|-------------|
| `:s/old/new/` | Replace first | Replace first occurrence in line |
| `:s/old/new/g` | Replace all in line | Replace all occurrences in line |
| `:%s/old/new/g` | Replace all in file | Replace all occurrences in file |
| `:%s/old/new/gc` | Replace with confirm | Replace all with confirmation |

---

## 📋 Copy, Cut & Paste

### Basic Operations
| Command | Action | Description |
|---------|--------|-------------|
| `yy` | Yank line | Copy current line |
| `y{motion}` | Yank motion | Copy text (e.g., `yw` = word) |
| `dd` | Delete line | Cut current line |
| `d{motion}` | Delete motion | Cut text (e.g., `dw` = word) |
| `p` | Paste after | Paste after cursor |
| `P` | Paste before | Paste before cursor |
| `x` | Delete char | Delete character under cursor |
| `X` | Delete char before | Delete character before cursor |

---

## 🔧 Plugins & Extensions

### Installed Plugins
1. **NERDTree** - File explorer
2. **vim-airline** - Status line enhancement
3. **vim-css-color** - CSS color highlighting  
4. **easymotion** - Fast navigation
5. **emmet-vim** - HTML/CSS expansion

### EasyMotion Commands
| Command | Action | Description |
|---------|--------|-------------|
| `<Leader><Leader>w` | Jump to word | Jump to any word |
| `<Leader><Leader>f{char}` | Find character | Jump to character |
| `<Leader><Leader>j` | Jump down | Jump to lines below |
| `<Leader><Leader>k` | Jump up | Jump to lines above |

### Emmet Commands (HTML/CSS)
| Command | Action | Description |
|---------|--------|-------------|
| `Ctrl+y,` | Expand | Expand emmet abbreviation |
| `div.class` + `Ctrl+y,` | Create div | `<div class="class"></div>` |
| `ul>li*3` + `Ctrl+y,` | Create list | Unordered list with 3 items |

---

## 💾 File Operations

### File Commands
| Command | Action | Description |
|---------|--------|-------------|
| `:w` | Save | Save current file |
| `:w filename` | Save as | Save with new filename |
| `:q` | Quit | Quit vim (if no changes) |
| `:q!` | Force quit | Quit without saving |
| `:wq` | Save & quit | Save and quit |
| `:x` | Save & quit | Save and quit (alternative) |
| `ZZ` | Save & quit | Save and quit (normal mode) |
| `ZQ` | Quit without save | Quit without saving |

### Buffer Management
| Command | Action | Description |
|---------|--------|-------------|
| `:e filename` | Edit file | Open file for editing |
| `:b#` | Previous buffer | Switch to previous buffer |
| `:bn` | Next buffer | Switch to next buffer |
| `:bp` | Previous buffer | Switch to previous buffer |
| `:bd` | Delete buffer | Close current buffer |
| `:ls` | List buffers | Show all open buffers |

---

## 🔄 Undo & Redo

### History Commands
| Command | Action | Description |
|---------|--------|-------------|
| `u` | Undo | Undo last change |
| `Ctrl+r` | Redo | Redo last undone change |
| `:earlier 5m` | Time travel | Go back 5 minutes |
| `:later 5m` | Time travel | Go forward 5 minutes |

---

## 🎨 Visual Mode

### Visual Selection
| Command | Action | Description |
|---------|--------|-------------|
| `v` | Character visual | Select characters |
| `V` | Line visual | Select lines |
| `Ctrl+v` | Block visual | Select rectangular block |
| `gv` | Reselect | Reselect last visual area |

### Visual Mode Operations
| Command | Action | Description |
|---------|--------|-------------|
| `y` | Yank selection | Copy selected text |
| `d` | Delete selection | Cut selected text |
| `c` | Change selection | Delete and enter insert mode |
| `>` | Indent right | Indent selection right |
| `<` | Indent left | Indent selection left |
| `=` | Auto-indent | Auto-indent selection |

---

## ⚙️ Configuration Settings

### Key Settings in Your Config
```vim
" Leader key
let mapleader = " "

" Indentation
set tabstop=4          " Tab width: 4 spaces
set shiftwidth=4       " Indent width: 4 spaces  
set expandtab          " Use spaces instead of tabs
set autoindent         " Auto indentation
set smartindent        " Smart indentation

" Search
set incsearch          " Incremental search
set ignorecase         " Case-insensitive search
set smartcase          " Smart case sensitivity
set hlsearch           " Highlight search results

" Display
set number             " Line numbers
set scrolloff=10       " Keep 10 lines visible when scrolling
set nowrap             " Don't wrap long lines
set showcmd            " Show partial commands
set showmode           " Show current mode
set showmatch          " Show matching brackets

" History & Completion
set history=1000       " Command history: 1000 entries
set wildmenu           " Enhanced command completion
set wildmode=list:longest  " Bash-like completion
```

---

## 🆘 Quick Help

### Get Help
| Command | Action | Description |
|---------|--------|-------------|
| `:help` | General help | Open vim help |
| `:help {topic}` | Specific help | Help for specific topic |
| `:help {key}` | Key help | Help for specific key |
| `Ctrl+]` | Follow link | Follow help link |
| `Ctrl+o` | Go back | Go back in help |

### Plugin Installation
```vim
" To install plugins:
1. Add plugin to vimrc between plug#begin() and plug#end()
2. Restart vim or :source ~/.vimrc
3. Run :PlugInstall
```

---

## 🔥 Pro Tips

### Efficiency Hacks
- Use `jk` instead of `Esc` for faster mode switching
- Use `H` and `L` for quick line beginning/end navigation
- Use `J` and `K` for fast vertical movement (5 lines at once)
- Use `Space+n` to quickly access file explorer
- Use `Ctrl+t` to toggle file tree while coding

### Common Workflows
1. **Quick File Navigation**: `Ctrl+t` → navigate → `Enter` → edit
2. **Fast Editing**: `jk` → navigate → `i` → edit → `jk` → save
3. **Window Management**: `Ctrl+h/j/k/l` for quick window switching
4. **Search & Replace**: `/pattern` → `n` → `:%s//replacement/g`

### Customization
- All settings are in `~/.vimrc`
- Plugin settings in `~/.vim/plugged/`
- Color scheme: Monokai (can be changed in vimrc)
- Backup location: `~/.vim/backup/`

---

*💡 **Remember**: Practice these commands daily to build muscle memory. Start with the basics and gradually incorporate advanced features!*
