# 🚀 Master Vim in VSCode - Complete Practice Guide

> **Mission**: Achieve fastest coding speed with VSCode Vim extension using consistency and full power of Vim

---

## 📋 Table of Contents

1. [VSCode Vim Configuration](#-vscode-vim-configuration)
2. [Essential Vim Motions](#-essential-vim-motions)
3. [Power Combos & Shortcuts](#-power-combos--shortcuts)
4. [Advanced Techniques](#-advanced-techniques)
5. [Daily Practice Exercises](#-daily-practice-exercises)
6. [Custom Shortcuts Mastery](#-custom-shortcuts-mastery)

---

## ⚙️ VSCode Vim Configuration

### 1. Core Settings (settings.json)

```jsonc
{
  // Enable Vim superpowers
  "vim.easymotion": true,           // Jump anywhere instantly
  "vim.hlsearch": true,             // Highlight search results
  "vim.leader": "<Space>",          // Space as leader key (ergonomic!)
  "vim.foldfix": true,              // Better folding support
  "vim.useSystemClipboard": true,   // Share clipboard with OS
  "editor.lineNumbers": "relative", // Relative numbers for fast jumps
  
  // Status bar visual feedback
  "vim.statusBarColorControl": true,
  "vim.statusBarColors.normal": ["#8FBCBB", "#434C5E"],
  "vim.statusBarColors.insert": "#BF616A",
  "vim.statusBarColors.visual": "#B48EAD",
  
  // Keep VSCode shortcuts that matter
  "vim.handleKeys": {
    "<C-a>": false,  // Select all
    "<C-f>": false,  // Find
    "<C-v>": false,  // Paste
    "<C-c>": false   // Copy
  }
}
```

### 2. Essential Keybindings (already configured)

```jsonc
// Insert Mode - Quick Escape
"vim.insertModeKeyBindingsNonRecursive": [
  {
    "before": ["j", "k"],    // Type 'jk' fast to escape
    "after": ["<ESC>"]
  }
]

// Normal Mode - Leader Shortcuts
"vim.normalModeKeyBindingsNonRecursive": [
  // Command Palette
  { "before": ["<leader>", "p"], "commands": ["workbench.action.showCommands"] },
  
  // Window Management
  { "before": ["<leader>", "s", "b"], "commands": ["workbench.action.toggleSidebarVisibility"] },
  { "before": ["<leader>", "c", "w"], "commands": ["workbench.action.closeActiveEditor"] },
  { "before": ["<leader>", "c", "a"], "commands": ["workbench.action.closeAllEditors"] },
  { "before": ["<leader>", "c", "o"], "commands": ["workbench.action.closeEditorsInOtherGroups"] },
  { "before": ["<leader>", "z", "m"], "commands": ["workbench.action.toggleZenMode"] },
  
  // Fast Line Movement
  { "before": ["J"], "after": ["5", "j"] },  // Jump 5 lines down
  { "before": ["K"], "after": ["5", "k"] },  // Jump 5 lines up
  { "before": ["H"], "after": ["^"] },       // Jump to line start
  { "before": ["L"], "after": ["g", "_"] },  // Jump to line end
  
  // Split Navigation (Ctrl + hjkl)
  { "before": ["<C-h>"], "after": ["<C-w>", "h"] },
  { "before": ["<C-j>"], "after": ["<C-w>", "j"] },
  { "before": ["<C-k>"], "after": ["<C-w>", "k"] },
  { "before": ["<C-l>"], "after": ["<C-w>", "l"] },
  
  // Tab Management
  { "before": ["<leader>", "t", "t"], "commands": [":tabnew"] },
  { "before": ["<leader>", "t", "n"], "commands": [":tabnext"] },
  { "before": ["<leader>", "t", "p"], "commands": [":tabprev"] },
  { "before": ["<leader>", "t", "o"], "commands": [":tabo"] },
  
  // Smart Line Creation
  { "before": ["o"], "after": ["o", "<ESC>"] },  // Insert line below
  { "before": ["O"], "after": ["O", "<ESC>"] },  // Insert line above
  
  // Clear Search Highlight
  { "before": ["<leader>", "/"], "commands": [":noh"] }
]

// Visual Mode - Better Copy
"vim.visualModeKeyBindingsNonRecursive": [
  {
    "before": ["g", "y"],
    "after": ["y", "`", "y"]  // Copy and return to original position
  }
]
```

---

## 🎯 Essential Vim Motions

### 1. Basic Movement (HJKL on steroids)

| Key | Action | Speed Tip |
|-----|--------|-----------|
| `h` / `l` | Left/Right | Use `w` `b` instead for words |
| `j` / `k` | Down/Up | Use `J` `K` (5 lines) for speed |
| `w` / `b` | Next/Previous word | **Master these first!** |
| `e` | End of word | Great for editing |
| `0` / `$` | Line start/end | Use `H` / `L` (custom) |
| `gg` / `G` | File start/end | Essential navigation |
| `{` / `}` | Paragraph up/down | Fast code block jumps |

**Practice Drill**: Navigate code without using arrow keys for 1 hour!

### 2. Search & Jump (Lightning Fast)

| Command | Action | Power Combo |
|---------|--------|-------------|
| `/text` | Search forward | `/func` then `n` `n` `n` |
| `?text` | Search backward | Great for reviewing |
| `n` / `N` | Next/Previous match | Combine with `cgn` to replace! |
| `*` / `#` | Search word under cursor | **Fastest search ever!** |
| `f{char}` | Jump to char on line | `fa` → jump to 'a' |
| `t{char}` | Jump before char | `dt;` → delete until ';' |
| `;` / `,` | Repeat f/t forward/back | Chain jumps: `fa;fa;fa` |

**Power Move**: `*` → `cgn` → type replacement → `.` `.` `.` (replace all occurrences)

### 3. Text Objects (The Secret Weapon)

| Object | Description | Example Usage |
|--------|-------------|---------------|
| `iw` / `aw` | Inner/Around word | `ciw` = change word |
| `i"` / `a"` | Inside/Around quotes | `ci"` = change string |
| `i(` / `a(` | Inside/Around parens | `da(` = delete with parens |
| `i{` / `a{` | Inside/Around braces | `vi{` = select block |
| `it` / `at` | Inside/Around tags | `cit` = change HTML tag |
| `ip` / `ap` | Inside/Around paragraph | `dap` = delete paragraph |

**Game Changer Combos**:
```
ciw  → Change inner word
ci"  → Change inside quotes
ci(  → Change inside parentheses
ci{  → Change inside braces
cit  → Change inside HTML/XML tag
diw  → Delete word
da(  → Delete including parentheses
vi{  → Visual select code block
```

---

## 💪 Power Combos & Shortcuts

### 1. Operator + Motion = Magic

**Formula**: `[operator][count][motion]`

| Combo | Action | Real Example |
|-------|--------|--------------|
| `d3w` | Delete 3 words | Clean up quick |
| `c2j` | Change 2 lines down | Refactor code |
| `y$` | Yank to line end | Copy rest of line |
| `gU3w` | Uppercase 3 words | FIX CONSTANTS |
| `>2j` | Indent 2 lines down | Format code |
| `=a{` | Auto-indent block | **Format function!** |

### 2. Visual Mode Mastery

| Command | Action | Use Case |
|---------|--------|----------|
| `v` | Visual char mode | Select text precisely |
| `V` | Visual line mode | Select whole lines |
| `<C-v>` | Visual block mode | **Multi-cursor editing!** |
| `gv` | Reselect last visual | Redo selection |
| `o` | Toggle cursor end | Adjust selection |

**Visual Block Magic** (Multi-cursor alternative):
```
1. <C-v>         → Enter visual block
2. jjjj          → Select 4 lines
3. I             → Insert at start
4. //            → Type comment
5. <ESC>         → Apply to all lines!
```

### 3. Change & Replace Speed

| Command | Action | Pro Tip |
|---------|--------|---------|
| `cw` | Change word | Most used! |
| `cc` | Change line | `S` also works |
| `C` | Change to line end | Fast refactor |
| `r{char}` | Replace single char | `ra` → replace with 'a' |
| `R` | Replace mode | Overwrite text |
| `s` | Substitute char | `s` = `cl` |
| `~` | Toggle case | Make lowercase/uppercase |

**Speed Combo**: `*` (search word) → `cgn` (change next) → type new text → `.` (repeat)

### 4. Copy/Paste (Yank & Put)

| Command | Action | Speed Boost |
|---------|--------|-------------|
| `yy` / `Y` | Yank line | `3yy` = yank 3 lines |
| `p` / `P` | Paste after/before | Muscle memory this! |
| `"0p` | Paste from yank register | Ignore deletions |
| `"+y` | Yank to system clipboard | Share with outside |
| `"+p` | Paste from system | Get from outside |
| `xp` | Swap two chars | Typo fixer! |
| `ddp` | Swap two lines | Move line down |

**Pro Clipboard**: Use `vim.useSystemClipboard: true` so `y` and `p` work with OS!

---

## 🔥 Advanced Techniques

### 1. Registers (Multiple Clipboards)

```vim
"ayy    → Yank line to register 'a'
"ap     → Paste from register 'a'
"byy    → Yank to register 'b'
"bp     → Paste from register 'b'

:reg    → View all registers
"0p     → Paste last yank (ignore deletes)
".p     → Paste last insert
```

**Use Case**: Copy multiple snippets, paste anywhere later!

### 2. Macros (Record & Replay)

```vim
qa           → Start recording to register 'a'
[commands]   → Do your edits
q            → Stop recording
@a           → Replay macro
@@           → Replay last macro
100@a        → Replay 100 times!
```

**Example Macro**: Add semicolons to end of lines
```
qa        → Record to 'a'
A;        → Append semicolon
<ESC>     → Back to normal
j         → Next line
q         → Stop
10@a      → Apply to 10 lines
```

### 3. Marks & Jumps

```vim
ma       → Set mark 'a' at cursor
`a       → Jump to mark 'a' (exact position)
'a       → Jump to line of mark 'a'
`.       → Jump to last change
``       → Jump to last jump position
<C-o>    → Jump to older position
<C-i>    → Jump to newer position
```

**Workflow**: Mark important spots (`ma`, `mb`), code freely, jump back (`'a`)!

### 4. Dot Command (Repeat Last Change)

The `.` command is **THE MOST POWERFUL** Vim feature!

```vim
ciw + new_text + <ESC>   → Change word
.                        → Repeat on next word!

*                        → Search word
cgn + replacement        → Change next occurrence
.                        → Repeat change
.                        → Keep repeating!
```

**Rule**: Always think "Can I repeat this with `.`?"

### 5. Search & Replace (Bulk Edits)

```vim
:%s/old/new/g          → Replace all in file
:%s/old/new/gc         → Replace with confirmation
:s/old/new/g           → Replace in current line
:'<,'>s/old/new/g      → Replace in visual selection
:%s/\<word\>/new/g     → Replace whole word only
```

**Fast Method**: Use `/` search + `cgn` + `.` instead!

### 6. Surround Plugin (VSCodeVim built-in)

```vim
ysiw"    → Surround word with "
cs"'     → Change " to '
ds"      → Delete surrounding "
yss)     → Surround line with ()
S"       → Surround visual selection with "
```

### 7. EasyMotion (Teleport Anywhere)

```vim
<leader><leader>w    → Jump to word
<leader><leader>f    → Find character
<leader><leader>j    → Jump to line below
<leader><leader>k    → Jump to line above
```

**Speed**: Type `,,w` → see labels → type label → **BOOM teleported!**

---

## 📚 Custom Shortcuts Mastery

### Your Current Leader Key Shortcuts

| Shortcut | Action | When to Use |
|----------|--------|-------------|
| `<Space>p` | Command palette | Access any command |
| `<Space>sb` | Toggle sidebar | More screen space |
| `<Space>cw` | Close tab | Clean workspace |
| `<Space>ca` | Close all tabs | Fresh start |
| `<Space>co` | Close other tabs | Focus mode |
| `<Space>zm` | Zen mode | Deep focus coding |
| `<Space>/` | Clear search highlight | Clean screen |
| `<Space>tt` | New tab | Open new file |
| `<Space>tn` | Next tab | Navigate tabs |
| `<Space>tp` | Previous tab | Navigate tabs |
| `<Space>to` | Close other tabs | Focus current |

### Window Navigation (Ergonomic!)

| Shortcut | Action | Speed Benefit |
|----------|--------|---------------|
| `<C-h>` | Focus left split | No mouse! |
| `<C-j>` | Focus down split | Stay in home row |
| `<C-k>` | Focus up split | Lightning fast |
| `<C-l>` | Focus right split | Muscle memory |

### Recommended Additional Shortcuts

Add these to your `settings.json`:

```jsonc
// Quick File Navigation
{
  "before": ["<leader>", "e"],
  "commands": ["workbench.action.quickOpen"]
},

// Git Integration
{
  "before": ["<leader>", "g", "s"],
  "commands": ["workbench.view.scm"]
},
{
  "before": ["<leader>", "g", "d"],
  "commands": ["git.openChange"]
},

// Terminal Toggle
{
  "before": ["<leader>", "`"],
  "commands": ["workbench.action.terminal.toggleTerminal"]
},

// Find in Files
{
  "before": ["<leader>", "f", "f"],
  "commands": ["workbench.action.findInFiles"]
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

// Code Navigation
{
  "before": ["g", "d"],
  "commands": ["editor.action.revealDefinition"]
},
{
  "before": ["g", "r"],
  "commands": ["editor.action.goToReferences"]
},
{
  "before": ["g", "h"],
  "commands": ["editor.action.showHover"]
}
```

---

## 🎓 Daily Practice Exercises

### Week 1: Motion Mastery

**Day 1-2**: Basic Navigation
- [ ] Navigate entire file using only `hjkl`, `w`, `b`, `e`
- [ ] Use `gg`, `G`, `{`, `}` for big jumps
- [ ] Practice `H`, `L` for line start/end

**Day 3-4**: Search & Jump
- [ ] Use `f`, `t`, `;`, `,` for intra-line navigation
- [ ] Practice `*` to search word under cursor
- [ ] Use `n`, `N` to navigate search results

**Day 5-7**: Text Objects
- [ ] Master `ciw`, `ci"`, `ci(`, `ci{`
- [ ] Practice `diw`, `dap`, `da{`
- [ ] Use `vi{`, `va(` for visual selection

### Week 2: Editing Speed

**Day 1-3**: Change Operations
- [ ] Use `cw`, `c$`, `cc` extensively
- [ ] Practice `r`, `R` for replacements
- [ ] Master `s`, `S` for substitution

**Day 4-5**: Yank & Put
- [ ] Copy with `yy`, `y$`, `yiw`
- [ ] Paste with `p`, `P`
- [ ] Use `"0p` for yank-only paste

**Day 6-7**: Dot Command Mastery
- [ ] Make changes and repeat with `.`
- [ ] Practice `*` → `cgn` → `.` workflow
- [ ] Chain operations that work with `.`

### Week 3: Advanced Power

**Day 1-2**: Visual Mode
- [ ] Use `v`, `V`, `<C-v>` for selections
- [ ] Practice visual block editing
- [ ] Master `gv` to reselect

**Day 3-4**: Macros
- [ ] Record simple macros with `q`
- [ ] Replay with `@`, `@@`
- [ ] Create useful macros for your workflow

**Day 5-7**: Marks & Registers
- [ ] Set marks with `ma`, `mb`
- [ ] Jump with `` `a ``, `'a`
- [ ] Use named registers `"a`, `"b`

### Week 4: Workflow Integration

**Daily Practice**:
- [ ] Code entire day WITHOUT mouse
- [ ] Use leader shortcuts for all commands
- [ ] Create 3 custom shortcuts for your needs
- [ ] Record 1 macro to automate repetitive task

---

## 🏆 Master Level Challenges

### Challenge 1: No Mouse Week
- Complete all coding tasks without touching mouse
- Navigate files using only keyboard
- Use Vim motions for all text editing

### Challenge 2: Speed Refactoring
- Rename variable in entire file: `*` → `cgn` → new name → `.` `.` `.`
- Change all strings from `"` to `'`: `:%s/"/'/g`
- Comment 20 lines: `<C-v>` → select → `I//` → `<ESC>`

### Challenge 3: Macro Mastery
- Create macro to format function calls
- Create macro to add logging statements
- Create macro to convert array to object

### Challenge 4: Text Object Ninja
- Delete function body: `di{`
- Change HTML tag content: `cit`
- Select entire function: `va{`
- Change function arguments: `ci(`

---

## 🎯 Muscle Memory Drills

### Morning Warm-up (5 minutes)

```
1. Open any file
2. Navigate using only: w, b, e, {, }, gg, G
3. Search using: *, /, n, N
4. Make edits using: ciw, ci", ci(, cit
5. Copy/paste using: yy, p, P
6. Use dot command: . . . .
```

### Afternoon Practice (10 minutes)

```
1. Use visual block mode: <C-v>
2. Record a macro: qa ... q
3. Replay macro: @a, @@
4. Set marks: ma, mb, mc
5. Jump to marks: `a, `b, `c
6. Use registers: "ayy, "ap
```

### Evening Review (5 minutes)

```
1. Practice leader shortcuts
2. Navigate splits with <C-hjkl>
3. Use EasyMotion: ,,w
4. Apply search & replace: :%s/old/new/g
5. Review your custom shortcuts
```

---

## 📊 Progress Tracking

### Beginner (Week 1-2)
- ✅ Navigate without arrow keys
- ✅ Use basic motions (w, b, e)
- ✅ Master text objects (ciw, ci", ci()
- ✅ Copy/paste efficiently

### Intermediate (Week 3-4)
- ✅ Use visual modes comfortably
- ✅ Create and use macros
- ✅ Master dot command workflow
- ✅ Navigate with marks

### Advanced (Week 5-8)
- ✅ Code without mouse entirely
- ✅ Use registers effectively
- ✅ Custom shortcuts for your workflow
- ✅ Teach Vim to someone else

### Expert (Week 9+)
- ✅ Contribute to Vim community
- ✅ Create custom Vim plugins
- ✅ Code 2x faster than before
- ✅ Help others master Vim

---

## 🔗 Quick Reference Card

### Essential Shortcuts (Print This!)

```
┌─────────────────── NAVIGATION ────────────────────┐
│ h j k l    → Basic movement                       │
│ w b e      → Word navigation                      │
│ H L        → Line start/end (custom)              │
│ J K        → Jump 5 lines (custom)                │
│ { }        → Paragraph up/down                    │
│ gg G       → File start/end                       │
│ * #        → Search word under cursor             │
│ f t ; ,    → Find char on line                    │
└───────────────────────────────────────────────────┘

┌─────────────────── TEXT OBJECTS ──────────────────┐
│ ciw ci" ci( ci{ cit → Change inside               │
│ diw di" di( di{ dit → Delete inside               │
│ viw vi" vi( vi{ vit → Visual select inside        │
│ caw ca" ca( ca{ cat → Change around               │
└───────────────────────────────────────────────────┘

┌─────────────────── EDITING ───────────────────────┐
│ cw cc C    → Change word/line/to-end              │
│ dd D       → Delete line/to-end                   │
│ yy Y       → Yank line                            │
│ p P        → Paste after/before                   │
│ u <C-r>    → Undo/Redo                            │
│ .          → Repeat last change                   │
│ r R        → Replace char/mode                    │
│ o O        → New line below/above (custom)        │
└───────────────────────────────────────────────────┘

┌─────────────────── LEADER (<Space>) ──────────────┐
│ <Space>p     → Command palette                    │
│ <Space>sb    → Toggle sidebar                     │
│ <Space>cw    → Close tab                          │
│ <Space>ca    → Close all tabs                     │
│ <Space>zm    → Zen mode                           │
│ <Space>/     → Clear search                       │
│ <Space>tt/tn/tp → Tab management                  │
└───────────────────────────────────────────────────┘

┌─────────────────── POWER MOVES ───────────────────┐
│ * cgn . . .       → Replace all occurrences       │
│ <C-v> I text ESC  → Multi-line insert             │
│ qa [cmds] q @a    → Record and replay macro       │
│ ma `a             → Set mark and jump             │
│ :%s/old/new/g     → Search and replace all        │
│ =a{               → Auto-indent block             │
└───────────────────────────────────────────────────┘
```

---

## 💡 Pro Tips

1. **Think in Text Objects**: Instead of "delete 3 words", think "delete inside quotes" (`ci"`)

2. **Master Dot Command**: Make repeatable changes. `*` + `cgn` + `.` is faster than search & replace

3. **Use Relative Line Numbers**: Jump to line 5 down with `5j`, not counting manually

4. **Leader Key is Your Friend**: `<Space>` is easier than `\` for leader key

5. **jk for Escape**: Type `jk` fast to exit insert mode - saves pinky strain!

6. **Visual Block = Multi-cursor**: Don't miss mouse multi-cursor - use `<C-v>` instead

7. **Marks for Navigation**: Set marks (`ma`) at important places, jump back anytime

8. **Registers for Clipboard**: Use `"a`, `"b` for multiple clipboards - game changer!

9. **EasyMotion for Long Jumps**: `,,w` is faster than counting lines

10. **Practice Daily**: 5 minutes morning drill = muscle memory = 2x speed in 1 month!

---

## 🎬 Next Steps

1. **Install VSCodeVim Extension**: Already done! ✅

2. **Apply Configuration**: Copy settings from your `vscode/settings.json` ✅

3. **Start Week 1 Practice**: Follow daily exercises above

4. **Join Community**:
   - [VSCodeVim GitHub](https://github.com/VSCodeVim/Vim)
   - [r/vim Reddit](https://reddit.com/r/vim)
   - [Vim Adventures Game](https://vim-adventures.com/)

5. **Track Progress**: Mark completed exercises each day

6. **Teach Others**: Best way to master = teach someone else!

---

## 🌟 Remember

> **"Vim is not about speed on day 1. It's about speed on day 100."**

- Be patient with learning curve
- Practice deliberately, not casually  
- Focus on muscle memory, not memorization
- Use Vim everywhere: comments, git commits, notes
- Have fun! Vim is a superpower once mastered

---

**Happy Vimming! 🚀**

*Master the art of never touching the mouse again!*
