# 🏋️ Vim Daily Drills - Muscle Memory Training

> **Goal**: Build muscle memory through deliberate practice. 5-10 minutes daily = 2x speed in 30 days!

---

## 📅 30-Day Vim Challenge

### Week 1: Foundation (Days 1-7)

#### Day 1: Basic Motion
**Focus**: Navigate without arrow keys
```
Practice file: Any code file
Duration: 10 minutes

Drill:
1. Use only hjkl (no arrow keys!)
2. Navigate 100 lines using j/k
3. Move to start/end of 20 lines using H/L (custom: ^ and g_)
4. Jump to file top/bottom 5 times (gg/G)

Success: Complete without touching arrow keys
```

#### Day 2: Word Navigation
**Focus**: Master w, b, e
```
Practice: Navigate JavaScript function
Duration: 10 minutes

Drill:
1. Jump forward 50 words using 'w'
2. Jump backward 50 words using 'b'
3. Jump to end of 20 words using 'e'
4. Combine: w w w b e w b

Challenge: Navigate entire function using only w/b/e
```

#### Day 3: Search & Jump
**Focus**: f, t, *, /
```
Practice: HTML/CSS file
Duration: 10 minutes

Drill:
1. Use 'f' to find 10 characters
2. Use 't' to jump before 10 characters
3. Use ';' to repeat 20 times
4. Use '*' to search 5 words
5. Use 'n' to navigate search results

Speed Goal: Find any character in <1 second
```

#### Day 4: Text Objects (Inner)
**Focus**: ciw, ci", ci(, ci{
```
Practice: Python/JavaScript file
Duration: 15 minutes

Drill - Change Inside:
1. Change 10 words: ciw
2. Change 10 strings: ci"
3. Change 5 function args: ci(
4. Change 5 code blocks: ci{
5. Change 5 HTML tags: cit

Challenge: Change 20 items without mistake
```

#### Day 5: Text Objects (Around)
**Focus**: caw, ca", ca(, ca{
```
Practice: Any code file
Duration: 15 minutes

Drill - Change Around:
1. Change 10 words with space: caw
2. Change 10 strings with quotes: ca"
3. Change 5 expressions with parens: ca(
4. Change 5 blocks with braces: ca{

Compare: Inner vs Around behavior
```

#### Day 6: Delete Operations
**Focus**: diw, di", di(, di{, dd
```
Practice: Refactoring code
Duration: 15 minutes

Drill - Delete:
1. Delete 20 words: diw
2. Delete 10 strings: di"
3. Delete 5 function calls: di(
4. Delete 5 code blocks: di{
5. Delete 10 lines: dd

Speed Goal: Delete any text object in <2 seconds
```

#### Day 7: Week 1 Review
**Focus**: Combine all Week 1 skills
```
Practice: Real coding task
Duration: 20 minutes

Challenge:
1. Navigate file using only Vim motions
2. Use text objects for all edits
3. No mouse, no arrow keys
4. Track mistakes

Goal: <5 mistakes in 20 minutes
```

---

### Week 2: Speed Editing (Days 8-14)

#### Day 8: Copy & Paste
**Focus**: yy, p, P, "0p
```
Practice: Code refactoring
Duration: 10 minutes

Drill:
1. Yank 20 lines: yy (or Y)
2. Paste after 20 times: p
3. Paste before 20 times: P
4. Use yank register: "0p after deletion
5. Yank words: yiw, paste: p

Challenge: Reorganize function without mouse
```

#### Day 9: Visual Mode
**Focus**: v, V, <C-v>
```
Practice: Code formatting
Duration: 15 minutes

Drill:
1. Select 10 words: viw
2. Select 10 lines: V
3. Select 5 blocks: vi{
4. Visual block select 10 columns: <C-v>
5. Change selection: c, delete: d, yank: y

Challenge: Comment 10 lines using <C-v>I
```

#### Day 10: Dot Command Mastery
**Focus**: . (repeat)
```
Practice: Repetitive edits
Duration: 15 minutes

Drill:
1. Change word + repeat 10 times: ciw ... ... ...
2. Delete line + repeat 5 times: dd . . . .
3. Indent block + repeat 3 times: >i{ . .
4. Add semicolon + repeat: A; <ESC> . . .

Power Move: * → cgn → type → . . . .
```

#### Day 11: Search & Replace
**Focus**: /, n, N, cgn
```
Practice: Variable renaming
Duration: 15 minutes

Drill:
1. Search 10 words: /word
2. Navigate results: n, N
3. Replace with cgn:
   * → search word
   cgn → change next
   type new text
   . . . → repeat

Challenge: Rename variable in 20 places
```

#### Day 12: Change Operations
**Focus**: cw, cc, C, r, R
```
Practice: Code editing
Duration: 15 minutes

Drill:
1. Change 20 words: cw
2. Change 10 lines: cc (or S)
3. Change to line end 10 times: C
4. Replace 20 chars: r
5. Replace mode 5 times: R

Speed Goal: Change any text in <3 seconds
```

#### Day 13: Macro Recording
**Focus**: qa, @a, @@
```
Practice: Repetitive task automation
Duration: 20 minutes

Drill - Record Macros:
1. Add semicolons:
   qa → A; <ESC> → j → q
   @a @a @a (or 10@a)

2. Comment lines:
   qa → I// <ESC> → j → q
   10@a

3. Wrap in quotes:
   qa → ciw"<C-r>""<ESC> → q
   @a on next words

Challenge: Create 3 useful macros
```

#### Day 14: Week 2 Review
**Focus**: Speed editing challenge
```
Practice: Timed coding task
Duration: 30 minutes

Challenge:
1. Refactor function using text objects
2. Rename variable using * → cgn → .
3. Format code using visual mode
4. Record macro for repetitive task
5. Track time and mistakes

Goal: Complete in <30 minutes, <3 mistakes
```

---

### Week 3: Advanced Power (Days 15-21)

#### Day 15: Marks & Jumps
**Focus**: ma, `a, ', <C-o>, <C-i>
```
Practice: Long file navigation
Duration: 15 minutes

Drill:
1. Set 5 marks: ma, mb, mc, md, me
2. Jump to marks 20 times: `a `b `c
3. Jump to mark line 10 times: 'a 'b
4. Use jump list: <C-o> <C-i>
5. Jump to last edit: `.

Workflow: Mark → Edit → Jump back → Repeat
```

#### Day 16: Registers
**Focus**: "a, "b, "0, "+
```
Practice: Multi-clipboard usage
Duration: 15 minutes

Drill:
1. Yank to register a: "ayy
2. Yank to register b: "byy
3. Paste from registers: "ap "bp
4. Use yank register: "0p
5. System clipboard: "+y "+p

Challenge: Manage 3 clipboards simultaneously
```

#### Day 17: Visual Block Magic
**Focus**: <C-v> + I, A, c, r
```
Practice: Multi-line editing
Duration: 20 minutes

Drill - Visual Block Operations:
1. Insert at start:
   <C-v> → select lines → I → type → <ESC>

2. Append at end:
   <C-v> → select lines → A → type → <ESC>

3. Replace chars:
   <C-v> → select → r → char

4. Change block:
   <C-v> → select → c → type → <ESC>

Challenge: Comment 10 lines with //
Challenge: Create ASCII art border
```

#### Day 18: Surround Operations
**Focus**: ys, cs, ds (VSCodeVim)
```
Practice: String and tag manipulation
Duration: 15 minutes

Drill:
1. Add quotes: ysiw"
2. Change quotes: cs"'
3. Delete quotes: ds"
4. Surround line: yss)
5. Visual surround: Vjj S}

Challenge: Convert all " to ' in function
```

#### Day 19: EasyMotion
**Focus**: <leader><leader>w, f, j, k
```
Practice: Long-distance jumping
Duration: 15 minutes

Drill:
1. Jump to words: ,,w → label
2. Find character: ,,f → char → label
3. Jump down: ,,j → label
4. Jump up: ,,k → label

Speed Goal: Jump anywhere in <2 seconds
```

#### Day 20: Advanced Search
**Focus**: /, \<\>, \c, \v
```
Practice: Regex search
Duration: 15 minutes

Drill:
1. Case insensitive: /word\c
2. Whole word only: /\<word\>
3. Very magic mode: /\vword
4. Search and replace: :%s/old/new/g
5. Visual replace: '<,'>s/old/new/g

Challenge: Complex pattern replacement
```

#### Day 21: Week 3 Review
**Focus**: Advanced techniques combination
```
Practice: Complex refactoring
Duration: 30 minutes

Challenge:
1. Use marks for navigation
2. Use registers for multiple clipboards
3. Use visual block for multi-line edits
4. Use EasyMotion for quick jumps
5. Record macros to automate

Goal: Complete complex task using all tools
```

---

### Week 4: Workflow Mastery (Days 22-28)

#### Day 22: Leader Shortcuts
**Focus**: <Space> combinations
```
Practice: VSCode integration
Duration: 15 minutes

Drill - Your Custom Shortcuts:
1. Command palette: <Space>p
2. Toggle sidebar: <Space>sb
3. Close tabs: <Space>cw, ca, co
4. Zen mode: <Space>zm
5. Clear search: <Space>/
6. Tab management: <Space>tt, tn, tp

Challenge: Complete task using only keyboard
```

#### Day 23: Split Navigation
**Focus**: <C-h>, <C-j>, <C-k>, <C-l>
```
Practice: Multi-pane editing
Duration: 15 minutes

Drill:
1. Open 4 splits
2. Navigate using Ctrl+hjkl
3. Resize panes
4. Move content between panes
5. Close panes efficiently

Goal: Never use mouse for split management
```

#### Day 24: Code Navigation
**Focus**: gd, gr, gh (LSP integration)
```
Practice: Large codebase
Duration: 15 minutes

Drill:
1. Go to definition: gd (10 times)
2. Find references: gr (10 times)
3. Show hover: gh (10 times)
4. Go back: <C-o>
5. Jump forward: <C-i>

Workflow: gd → read → <C-o> → continue
```

#### Day 25: Git Integration
**Focus**: <leader>g shortcuts
```
Practice: Version control workflow
Duration: 15 minutes

Drill:
1. Git status: <Space>gs
2. View diff: <Space>gd
3. Stage changes
4. Commit with Vim
5. Navigate changes

Challenge: Complete git workflow without GUI
```

#### Day 26: Refactoring Power
**Focus**: <leader>r shortcuts
```
Practice: Code refactoring
Duration: 20 minutes

Drill:
1. Rename symbol: <Space>rr
2. Format document: <Space>rf
3. Extract function
4. Inline variable
5. Use text objects for refactoring

Challenge: Refactor function using only Vim
```

#### Day 27: Terminal Integration
**Focus**: <leader>` toggle
```
Practice: Development workflow
Duration: 15 minutes

Drill:
1. Toggle terminal: <Space>`
2. Run commands
3. Navigate output
4. Copy from terminal
5. Return to code

Workflow: Code → Terminal → Test → Repeat
```

#### Day 28: Week 4 Review
**Focus**: Complete workflow mastery
```
Practice: Real project work
Duration: 1 hour

Challenge - No Mouse Day:
1. Write new feature
2. Refactor existing code
3. Debug issues
4. Commit changes
5. All with Vim motions

Goal: Productive coding without mouse
```

---

### Days 29-30: Final Challenge

#### Day 29: Speed Test
**Goal**: Measure your improvement
```
Test: Timed coding challenges
Duration: 45 minutes

Tasks:
1. Navigate 1000 lines in 2 minutes
2. Refactor function in 5 minutes
3. Rename variable 20 places in 1 minute
4. Format document in 30 seconds
5. Write macro in 1 minute

Compare: Day 1 speed vs Day 29 speed
```

#### Day 30: Teach Someone
**Goal**: Solidify knowledge
```
Activity: Teach Vim to colleague
Duration: 30 minutes

Cover:
1. Basic motions (hjkl, wbe)
2. Text objects (ciw, ci", ci()
3. Dot command
4. Visual mode
5. Your favorite shortcuts

Teaching = True mastery!
```

---

## 🎯 Quick Daily Warm-up (5 minutes)

Use this every morning before coding:

```vim
" 1. Navigation (1 min)
gg → G → { → } → H → L → w → b → e

" 2. Text Objects (1 min)
ciw → ci" → ci( → ci{ → cit

" 3. Edit Operations (1 min)
cc → cw → C → dd → D → yy → p

" 4. Search (1 min)
* → n → N → / → search → n

" 5. Repeat (1 min)
ciw → type → <ESC> → . . . .
```

---

## 📊 Progress Tracking

### Metrics to Track

| Day | Task Completion Time | Mistakes | Mouse Usage | Confidence (1-10) |
|-----|---------------------|----------|-------------|-------------------|
| 1   |                     |          |             |                   |
| 7   |                     |          |             |                   |
| 14  |                     |          |             |                   |
| 21  |                     |          |             |                   |
| 28  |                     |          |             |                   |
| 30  |                     |          |             |                   |

### Success Indicators

- ✅ Can code entire day without mouse
- ✅ Navigate faster than with mouse
- ✅ Text objects are second nature
- ✅ Use dot command automatically
- ✅ Created custom shortcuts
- ✅ Teaching others Vim

---

## 💪 Bonus Challenges

### Challenge 1: Vim Golf
Solve editing tasks in minimum keystrokes
- [VimGolf.com](https://www.vimgolf.com/)

### Challenge 2: Vim Adventures
Learn Vim through gaming
- [vim-adventures.com](https://vim-adventures.com/)

### Challenge 3: Speed Typing
Practice at [typing.io](https://typing.io/) with code

### Challenge 4: Vimium
Use Vim motions in browser
- Install Vimium extension

---

## 🏆 Rewards System

### After Week 1
- ✨ No arrow keys medal

### After Week 2
- 🚀 Speed editor badge

### After Week 3
- 💎 Vim ninja status

### After Week 4
- 👑 Vim master certification

### After Day 30
- 🏆 No mouse champion
- 🎓 Ready to teach others

---

## 📝 Daily Log Template

```
Date: ___________
Duration: ___________
Focus: ___________

What I practiced:
-
-
-

What I learned:
-
-
-

Mistakes made:
-
-

Tomorrow's focus:
-
-
```

---

**Remember**: 
> "Consistency beats intensity. 10 minutes daily > 2 hours weekly"

**Your mantra**:
> "I will not touch the mouse. I will not touch the arrow keys. I am Vim."

🚀 **Start Day 1 NOW!**
