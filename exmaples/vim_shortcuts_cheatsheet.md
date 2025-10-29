# 🎯 VSCode Vim Shortcuts - Ultimate Cheat Sheet

> **Print this and keep it visible while coding!**

---

## 🔥 Most Used (Top 20)

These will give you 80% of the power:

| Shortcut | Action | Frequency |
|----------|--------|-----------|
| `jk` | Exit insert mode | ⭐⭐⭐⭐⭐ |
| `w` / `b` | Next/Previous word | ⭐⭐⭐⭐⭐ |
| `ciw` | Change word | ⭐⭐⭐⭐⭐ |
| `ci"` | Change inside quotes | ⭐⭐⭐⭐⭐ |
| `ci(` | Change inside parens | ⭐⭐⭐⭐⭐ |
| `dd` | Delete line | ⭐⭐⭐⭐⭐ |
| `yy` / `p` | Copy/Paste line | ⭐⭐⭐⭐⭐ |
| `u` / `<C-r>` | Undo/Redo | ⭐⭐⭐⭐⭐ |
| `.` | Repeat last change | ⭐⭐⭐⭐⭐ |
| `*` | Search word | ⭐⭐⭐⭐⭐ |
| `n` / `N` | Next/Previous match | ⭐⭐⭐⭐⭐ |
| `f{char}` | Find character | ⭐⭐⭐⭐ |
| `gg` / `G` | File start/end | ⭐⭐⭐⭐ |
| `H` / `L` | Line start/end | ⭐⭐⭐⭐ |
| `J` / `K` | Jump 5 lines | ⭐⭐⭐⭐ |
| `<C-h/j/k/l>` | Navigate splits | ⭐⭐⭐⭐ |
| `<Space>p` | Command palette | ⭐⭐⭐⭐ |
| `<Space>cw` | Close tab | ⭐⭐⭐⭐ |
| `V` | Visual line mode | ⭐⭐⭐ |
| `<C-v>` | Visual block mode | ⭐⭐⭐ |

---

## 🚀 Navigation

### Basic Motion
```
h j k l          ← ↓ ↑ →  (never use arrow keys!)
w                Next word start
b                Previous word start
e                Word end
W B E            Same but WORD (space-separated)

H                Line start (custom: ^)
L                Line end (custom: g_)
J                Jump 5 lines down (custom)
K                Jump 5 lines up (custom)

0                Absolute line start
^                First non-blank character
$                Line end
g_               Last non-blank character
```

### Big Jumps
```
gg               Go to file start
G                Go to file end
{                Paragraph up
}                Paragraph down
%                Jump to matching bracket
[[               Previous section
]]               Next section

5j               Move down 5 lines
10k              Move up 10 lines
3w               Forward 3 words
```

### Screen Navigation
```
H                High (top of screen)
M                Middle of screen
L                Low (bottom of screen)

<C-u>            Half page up
<C-d>            Half page down
<C-b>            Page up
<C-f>            Page down

zt               Cursor to top
zz               Cursor to middle
zb               Cursor to bottom
```

---

## 🔍 Search & Jump

### Search
```
/pattern         Search forward
?pattern         Search backward
n                Next match
N                Previous match
*                Search word under cursor forward
#                Search word under cursor backward

<Space>/         Clear search highlight (custom)
```

### Find on Line
```
f{char}          Find character forward
F{char}          Find character backward
t{char}          Until character forward
T{char}          Until character backward
;                Repeat find forward
,                Repeat find backward

fa               Jump to next 'a'
3fa              Jump to 3rd 'a'
dt;              Delete until semicolon
```

### Marks & Jumps
```
ma               Set mark 'a'
`a               Jump to mark 'a' (exact position)
'a               Jump to line of mark 'a'
``               Jump to last position
'.               Jump to last change

<C-o>            Jump to older position
<C-i>            Jump to newer position
```

---

## ✂️ Text Objects (The Secret Weapon!)

### Inner Objects (exclude delimiters)
```
ciw              Change inner word
ci"              Change inside quotes
ci'              Change inside single quotes
ci(              Change inside parentheses
ci[              Change inside brackets
ci{              Change inside braces
ci<              Change inside angle brackets
cit              Change inside HTML tag
cip              Change inner paragraph

diw di" di( ...  Same but delete
viw vi" vi( ...  Same but visual select
yiw yi" yi( ...  Same but yank (copy)
```

### Around Objects (include delimiters)
```
caw              Change around word (with space)
ca"              Change around quotes
ca(              Change around parentheses
ca{              Change around braces
cat              Change around HTML tag
cap              Change around paragraph

daw da" da( ...  Same but delete
vaw va" va( ...  Same but visual select
yaw ya" ya( ...  Same but yank
```

### Common Use Cases
```
ciw              Change variable name
ci"              Change string content
ci(              Change function arguments
ci{              Change code block
cit              Change HTML tag content
diw              Delete word
da(              Delete with parentheses
vi{              Select entire function body
```

---

## ✏️ Editing

### Insert Modes
```
i                Insert before cursor
I                Insert at line start
a                Append after cursor
A                Append at line end
o                Insert line below (custom: o<ESC>)
O                Insert line above (custom: O<ESC>)

jk               Exit insert mode (custom)
<ESC>            Exit insert mode (default)
```

### Change Operations
```
cw               Change word
c2w              Change 2 words
c$               Change to line end
C                Change to line end (same as c$)
cc               Change entire line
S                Change entire line (same as cc)

3cw              Change 3 words
ci"              Change inside quotes
cit              Change inside tag
```

### Delete Operations
```
x                Delete character
X                Delete character before
dw               Delete word
d2w              Delete 2 words
d$               Delete to line end
D                Delete to line end (same as d$)
dd               Delete line

5dd              Delete 5 lines
diw              Delete word
di"              Delete inside quotes
da(              Delete with parentheses
```

### Replace
```
r{char}          Replace single character
R                Replace mode (overwrite)
~                Toggle case
gU{motion}       Uppercase
gu{motion}       Lowercase

ra               Replace with 'a'
gUiw             UPPERCASE word
guiw             lowercase word
```

---

## 📋 Copy & Paste (Yank & Put)

### Basic Copy/Paste
```
yy               Yank (copy) line
Y                Yank line (same as yy)
y{motion}        Yank motion
p                Paste after cursor/line
P                Paste before cursor/line

5yy              Yank 5 lines
y$               Yank to line end
yiw              Yank word
yi"              Yank inside quotes
```

### Smart Copy/Paste
```
"0p              Paste from yank register (ignore deletes)
"+y              Yank to system clipboard
"+p              Paste from system clipboard

xp               Swap two characters
ddp              Swap two lines
yyp              Duplicate line
```

### Registers (Multiple Clipboards)
```
"ayy             Yank line to register 'a'
"ap              Paste from register 'a'
"byy             Yank to register 'b'
"bp              Paste from register 'b'

:reg             View all registers
"_d              Delete to black hole (don't save)
```

---

## 👁️ Visual Mode

### Modes
```
v                Visual character mode
V                Visual line mode
<C-v>            Visual block mode
gv               Reselect last visual selection

<ESC>            Exit visual mode
```

### Selection
```
v + motion       Select with motion
viw              Select word
vi"              Select inside quotes
vi{              Select code block
vap              Select paragraph

V5j              Select 5 lines down
```

### Operations in Visual
```
(After selecting)
d                Delete selection
c                Change selection
y                Yank selection
>                Indent right
<                Indent left
=                Auto-indent
~                Toggle case
u                Lowercase
U                Uppercase
```

### Visual Block Magic
```
<C-v>            Enter visual block
j j j            Select lines
I                Insert at start
A                Append at end
c                Change block
r{char}          Replace all chars
<ESC>            Apply to all lines

Example: Comment multiple lines
<C-v> → select → I → // → <ESC>
```

---

## 🔄 Repeat & Undo

### Undo/Redo
```
u                Undo
<C-r>            Redo
U                Undo all changes on line
```

### Repeat
```
.                Repeat last change (MOST POWERFUL!)
;                Repeat last f/t/F/T
,                Repeat last f/t/F/T reverse
&                Repeat last substitution
@:               Repeat last command

Example: Change word and repeat
ciw + new_text + <ESC>
w w .            (repeat on next words)
```

### Power Combo: Search & Replace
```
*                Search word under cursor
cgn              Change next match
type new text
<ESC>
. . . . .        Repeat for each occurrence

(Faster than :%s/old/new/g!)
```

---

## 🎬 Macros (Record & Replay)

### Recording
```
qa               Start recording to register 'a'
[your commands]  Perform actions
q                Stop recording

@a               Replay macro 'a'
@@               Replay last macro
10@a             Replay macro 10 times
```

### Example Macros
```
1. Add semicolons to end of lines:
qa → A; → <ESC> → j → q
10@a

2. Comment multiple lines:
qa → I// → <ESC> → j → q
@a @a @a

3. Wrap words in quotes:
qa → ciw"<C-r>""<ESC> → q
@a on next words

4. Format JSON lines:
qa → I  → <ESC> → A, → j → q
```

---

## 🎨 VSCode Integration (Custom Shortcuts)

### Leader Key Shortcuts (`<Space>` = Leader)

#### Command & Navigation
```
<Space>p         Command palette (Ctrl+Shift+P)
<Space>e         Quick open files (Ctrl+P)
<Space>ff        Find in files
<Space>sb        Toggle sidebar
<Space>zm        Zen mode (focus!)
```

#### Window Management
```
<Space>cw        Close active tab
<Space>ca        Close all tabs
<Space>co        Close other tabs
<C-h>            Focus left split
<C-j>            Focus down split
<C-k>            Focus up split
<C-l>            Focus right split
```

#### Tab Management
```
<Space>tt        New tab
<Space>tn        Next tab
<Space>tp        Previous tab
<Space>to        Close other tabs
```

#### Git Integration
```
<Space>gs        Git status
<Space>gd        Git diff
<Space>gi        Last insert location
```

#### Code Actions
```
gd               Go to definition
gr               Find references
gh               Show hover info
<Space>rr        Rename symbol
<Space>rf        Format document
```

#### Terminal
```
<Space>`         Toggle terminal
<C-`>            New terminal (default VSCode)
```

---

## 🔧 Search & Replace

### Current File
```
:%s/old/new/g        Replace all in file
:%s/old/new/gc       Replace with confirmation
:s/old/new/g         Replace in current line
:'<,'>s/old/new/g    Replace in visual selection
:%s/\<word\>/new/g   Replace whole word only
:%s/old/new/gi       Case insensitive replace
```

### Patterns
```
:%s/foo/bar/g        Simple replacement
:%s/\<foo\>/bar/g    Whole word only
:%s/foo\|baz/bar/g   Multiple patterns
:%s/\(.*\)/"\1"/g    Add quotes around lines
:%s/\s\+$//g         Remove trailing spaces
```

---

## 🎯 Advanced Techniques

### Increment/Decrement
```
<C-a>            Increment number (disabled in config)
<C-x>            Decrement number (disabled in config)
```

### Folding
```
zf               Create fold
zo               Open fold
zc               Close fold
za               Toggle fold
zR               Open all folds
zM               Close all folds
```

### Indentation
```
>>               Indent line
<<               Unindent line
>i{              Indent block
=i{              Auto-indent block
==               Auto-indent line
gg=G             Auto-indent entire file
```

### Join Lines
```
J                Join line below to current
gJ               Join without space
3J               Join 3 lines
```

### Case Change
```
~                Toggle case
gU{motion}       Uppercase motion
gu{motion}       Lowercase motion
gUiw             UPPERCASE word
guiw             lowercase word
g~~              Toggle case entire line
```

---

## 🏆 Pro Combos

### Speed Editing
```
*cgn.            Search and replace all
<C-v>I//<ESC>    Comment multiple lines
=a{              Auto-format function
ggVG=            Format entire file
:%s/\s\+$//g     Remove trailing spaces
```

### Smart Selection
```
vi{              Select function body
va{              Select function with braces
vi"              Select string content
va"              Select string with quotes
vit              Select tag content
vat              Select tag with tags
```

### Navigation Combos
```
*                Search word
n n n            Jump through matches
<C-o>            Jump back
`               Jump to last position

ma               Set mark
[edit elsewhere]
`a               Jump back to mark
```

### Refactoring
```
* → cgn → new → .    Rename variable
vi{ → =              Format function
di{ → i → code       Replace function body
ci( → args           Change function args
```

---

## 📊 Keyboard Layout Reference

```
┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬─────────┐
│ `~ │ 1! │ 2@ │ 3# │ 4$ │ 5% │ 6^ │ 7& │ 8* │ 9( │ 0) │ -_ │ =+ │ BACKSP  │
├────┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬──────┤
│ TAB   │ Q  │ W→ │ E→ │ R  │ T  │ Y  │ U  │ I  │ O  │ P  │ [{ │ ]} │  |\  │
├───────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴──────┤
│ CAPS   │ A  │ S  │ D  │ F→ │ G  │ H← │ J↓ │ K↑ │ L→ │ ;: │ '" │  ENTER   │
├────────┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──────────┤
│ SHIFT     │ Z  │ X  │ C  │ V  │ B← │ N  │ M  │ ,< │ .> │ /? │   SHIFT    │
└─────┬─────┴─┬──┴───┴──┬─┴────┴────┴────┴────┴┬───┴──┬─┴────┴──┬──────────┘
      │ CTRL  │   ALT   │      SPACE (Leader)  │  ALT │  CTRL   │
      └───────┴─────────┴──────────────────────┴──────┴─────────┘

Legend:
W E → : Word navigation (w/e)
F T → : Find character (f/t)
H J K L : Motion keys (←↓↑→)
B ← : Back word (b)
SPACE : Leader key (<Space>)
```

---

## 💡 Remember

### The Vim Way
1. **Think in operations**: Not "delete 3 words", but "d3w"
2. **Text objects are king**: Use `ciw`, `ci"`, `ci(` instead of selecting
3. **Dot command**: Always ask "Can I repeat this with `.`?"
4. **Stay in normal mode**: Exit insert mode ASAP with `jk`
5. **Never touch mouse**: Force yourself for 30 days

### Learning Priority
1. ✅ Basic motion (hjkl, wbe, gg, G)
2. ✅ Text objects (ciw, ci", ci()
3. ✅ Dot command (.)
4. ✅ Visual mode (v, V, <C-v>)
5. ✅ Search (*, /, n)
6. ✅ Copy/paste (yy, p)
7. ✅ Macros (qa, @a)
8. ✅ Marks (ma, `a)
9. ✅ Registers ("a, "b)

### Speed Tips
- Use `H` and `L` instead of `0` and `$`
- Use `J` and `K` instead of `5j` and `5k`
- Use `*` instead of typing `/word`
- Use `ciw` instead of `bdw` + `i`
- Use `<C-hjkl>` to navigate splits
- Use `<Space>` shortcuts for VSCode commands

---

## 🎓 Practice Resources

1. **Vim Tutor**: Run `vimtutor` in terminal
2. **Vim Adventures**: https://vim-adventures.com/
3. **Vim Golf**: https://www.vimgolf.com/
4. **OpenVim Tutorial**: https://www.openvim.com/
5. **PacVim Game**: https://github.com/jmoon018/PacVim

---

**Print this cheat sheet and keep it visible!**

*Your journey to Vim mastery starts NOW! 🚀*
