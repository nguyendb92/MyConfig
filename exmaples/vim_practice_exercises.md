# 🎮 Vim Practice Exercises - Hands-On Training

> **Practice these exercises to build real Vim muscle memory**

---

## 🎯 Exercise 1: Navigation Speed Test

### Setup
Copy this text block and practice navigating:

```javascript
function calculateTotal(items) {
  const prices = items.map(item => item.price);
  const subtotal = prices.reduce((acc, price) => acc + price, 0);
  const tax = subtotal * 0.1;
  const shipping = subtotal > 50 ? 0 : 5.99;
  const total = subtotal + tax + shipping;
  
  return {
    subtotal: subtotal.toFixed(2),
    tax: tax.toFixed(2),
    shipping: shipping.toFixed(2),
    total: total.toFixed(2)
  };
}

const cart = [
  { name: "Laptop", price: 999.99, quantity: 1 },
  { name: "Mouse", price: 29.99, quantity: 2 },
  { name: "Keyboard", price: 79.99, quantity: 1 },
  { name: "Monitor", price: 299.99, quantity: 1 }
];

const result = calculateTotal(cart);
console.log("Order Summary:", result);
```

### Tasks (Time yourself!)
1. Jump to "function" word → Answer: `gg` then `w`
2. Jump to "return" statement → Answer: `/return` or `*` on "return"
3. Navigate to first "price" → Answer: `/price` then `n`
4. Jump between opening/closing braces → Answer: `%`
5. Navigate to last line → Answer: `G`
6. Jump back to first line → Answer: `gg`

**Target Time: < 30 seconds**

---

## 🎯 Exercise 2: Text Object Mastery

### Setup
Use the code above and perform these edits:

### Tasks
1. **Change variable name "items" to "products"**
   - Position cursor on "items"
   - Type: `ciw` → `products` → `<ESC>`
   - Repeat: `n` → `.` (search next, repeat change)

2. **Change string "Laptop" to "Gaming Laptop"**
   - Position cursor anywhere in "Laptop"
   - Type: `ci"` → `Gaming Laptop` → `<ESC>`

3. **Change number 999.99 to 1299.99**
   - Position cursor on number
   - Type: `ciw` → `1299.99` → `<ESC>`

4. **Delete entire function arguments**
   - Position cursor inside `(items)`
   - Type: `di(` (delete inside parentheses)

5. **Change entire return object**
   - Position cursor inside return `{}`
   - Type: `ci{` → start typing new object

6. **Delete one array element**
   - Position cursor on a line in array
   - Type: `dd` (delete line)

**Target: Complete all tasks in < 2 minutes**

---

## 🎯 Exercise 3: Visual Mode Challenge

### Setup
Copy this HTML block:

```html
<div class="container">
  <header>
    <h1>Welcome to My Site</h1>
    <nav>
      <a href="/">Home</a>
      <a href="/about">About</a>
      <a href="/contact">Contact</a>
    </nav>
  </header>
  
  <main>
    <article>
      <h2>Article Title</h2>
      <p>First paragraph of content goes here.</p>
      <p>Second paragraph with more information.</p>
      <p>Third paragraph to conclude the article.</p>
    </article>
    
    <aside>
      <h3>Related Links</h3>
      <ul>
        <li>Link One</li>
        <li>Link Two</li>
        <li>Link Three</li>
      </ul>
    </aside>
  </main>
  
  <footer>
    <p>Copyright 2025. All rights reserved.</p>
  </footer>
</div>
```

### Tasks
1. **Select entire `<header>` section**
   - Position on `<header>` line
   - Type: `V` → `j` `j` `j` `j` `j` `j` (or `vat` for tag)

2. **Select all `<p>` tag content**
   - Position inside `<p>` tag
   - Type: `vit` (visual inside tag)

3. **Select and delete all `<li>` items**
   - Position on first `<li>`
   - Type: `V` → `jj` → `d`

4. **Indent the entire `<main>` block**
   - Position on `<main>`
   - Type: `V` → select block → `>`
   - Or: `>i}` (indent inside braces)

5. **Comment multiple lines using Visual Block**
   - Position at start of lines
   - Type: `<C-v>` → `jjjj` → `I` → `//` → `<ESC>`

**Target: Complete in < 3 minutes**

---

## 🎯 Exercise 4: Search & Replace Speed

### Setup
Copy this configuration:

```json
{
  "theme": "dark",
  "language": "english",
  "notifications": true,
  "autoSave": true,
  "fontSize": 14,
  "tabSize": 2,
  "lineNumbers": true,
  "minimap": false,
  "wordWrap": true
}
```

### Tasks
1. **Change all "true" to "false"**
   - Method 1 (Vim way):
     - Type: `*` on "true" (search word)
     - Type: `cgn` → `false` → `<ESC>`
     - Type: `.` → `.` → `.` (repeat for each)
   
   - Method 2 (Command):
     - Type: `:%s/true/false/g`

2. **Change "dark" to "light"**
   - Type: `*` on "dark"
   - Type: `cgn` → `light` → `<ESC>`

3. **Change all numbers to 16**
   - Position on first number
   - Type: `ciw` → `16` → `<ESC>`
   - Find next: `/\d\+` (regex for numbers)
   - Repeat: `.`

4. **Add quotes around property names**
   - Example: `theme` → `"theme"`
   - Type: `ciw` → `"<C-r>""` → `<ESC>`
   - (Ctrl-r " inserts from clipboard)

**Target: Complete all in < 2 minutes**

---

## 🎯 Exercise 5: Macro Magic

### Setup
Create a file with this list:

```
apple
banana
orange
grape
melon
pear
peach
plum
```

### Task 1: Add bullet points
**Macro**: Add "- " to start of each line

```vim
qa           " Start recording to 'a'
I            " Insert at line start
- <Space>    " Type "- "
<ESC>        " Back to normal
j            " Down one line
q            " Stop recording

7@a          " Replay 7 times for remaining lines
```

**Result:**
```
- apple
- banana
- orange
- grape
- melon
- pear
- peach
- plum
```

### Task 2: Wrap in quotes and add comma
**Macro**: Change `apple` to `"apple",`

```vim
qa           " Start recording
I            " Insert at start
"            " Add opening quote
<ESC>        " Back to normal
A            " Append to end
",           " Add closing quote and comma
<ESC>        " Back to normal
j            " Next line
q            " Stop recording

7@a          " Replay for remaining
```

**Result:**
```
"apple",
"banana",
"orange",
"grape",
"melon",
"pear",
"peach",
"plum",
```

### Task 3: Create object properties
**Macro**: Convert to `name: "apple",`

```vim
qa           " Start recording
I            " Insert at start
name: "      " Type prefix
<ESC>        " Normal mode
A            " Append
",           " Add suffix
<ESC>        " Normal
j            " Next line
q            " Stop

7@a          " Apply to rest
```

**Result:**
```javascript
name: "apple",
name: "banana",
name: "orange",
name: "grape",
name: "melon",
name: "pear",
name: "peach",
name: "plum",
```

**Challenge**: Complete all 3 transformations in < 5 minutes

---

## 🎯 Exercise 6: Real-World Refactoring

### Setup
Copy this React component:

```javascript
function UserProfile(props) {
  return (
    <div className="profile">
      <img src={props.avatarUrl} alt={props.name} />
      <h2>{props.name}</h2>
      <p>{props.email}</p>
      <p>{props.bio}</p>
      <button onClick={props.onEdit}>Edit Profile</button>
    </div>
  );
}
```

### Task: Destructure props
**Goal**: Convert `props.x` to destructured variables

**Steps:**
1. Add destructuring to function params
   - Position on `(props)`
   - Type: `ci(` → `{ avatarUrl, name, email, bio, onEdit }` → `<ESC>`

2. Remove "props." from each usage
   - Method 1 (Search & Replace):
     - Type: `:%s/props\.//g`
   
   - Method 2 (Vim way):
     - Type: `*` on "props."
     - Type: `dgn` (delete next match)
     - Type: `.` `.` `.` `.` (repeat)

**Expected Result:**
```javascript
function UserProfile({ avatarUrl, name, email, bio, onEdit }) {
  return (
    <div className="profile">
      <img src={avatarUrl} alt={name} />
      <h2>{name}</h2>
      <p>{email}</p>
      <p>{bio}</p>
      <button onClick={onEdit}>Edit Profile</button>
    </div>
  );
}
```

**Target Time: < 1 minute**

---

## 🎯 Exercise 7: Multi-Cursor Alternative

### Setup
Copy this Python code:

```python
user1 = User()
user2 = User()
user3 = User()
user4 = User()
user5 = User()
```

### Task: Add .save() to each line

**Using Visual Block** (Vim way):
```vim
<C-v>        " Enter visual block
4j           " Select 5 lines
$            " Move to end
A            " Append
.save()      " Type the addition
<ESC>        " Apply to all lines
```

**Result:**
```python
user1 = User().save()
user2 = User().save()
user3 = User().save()
user4 = User().save()
user5 = User().save()
```

### Task 2: Add comments at start

```vim
<C-v>        " Visual block
4j           " Select lines
I            " Insert at start
# Active:    " Type comment
<ESC>        " Apply
```

**Result:**
```python
# Active: user1 = User().save()
# Active: user2 = User().save()
# Active: user3 = User().save()
# Active: user4 = User().save()
# Active: user5 = User().save()
```

**Challenge**: Complete both tasks in < 2 minutes

---

## 🎯 Exercise 8: Speed Editing Test

### Setup
Set a timer for 5 minutes. Complete as many tasks as possible:

```javascript
const data = {
  firstName: "john",
  lastName: "doe",
  age: 25,
  email: "john.doe@example.com",
  phone: "123-456-7890",
  address: {
    street: "123 main st",
    city: "anytown",
    state: "CA",
    zip: "12345"
  },
  active: true
};
```

### Tasks Checklist
- [ ] Capitalize all name values ("John", "Doe", "Main St", "Anytown")
- [ ] Change age from 25 to 26
- [ ] Update email domain to "company.com"
- [ ] Add a new property: `role: "admin"`
- [ ] Change "true" to "false"
- [ ] Add comma to last property
- [ ] Format entire object (indent)
- [ ] Add comment above object: `// User data`

### Vim Commands Reference
```vim
ciw          " Change word (for values)
ci"          " Change inside quotes
gUiw         " Uppercase word
ea           " Append to end of word
A,           " Add comma to end
O            " Insert line above
==           " Auto-indent line
=i{          " Auto-indent block
```

**Target: Complete 6+ tasks in 5 minutes**

---

## 🎯 Exercise 9: Navigation Olympics

### Setup
Open any large JavaScript/Python file (500+ lines)

### Tasks (Time each!)
1. **Jump to function definition**
   - Type: `/function` or `/def`
   - Time: ____ seconds

2. **Jump between 10 functions**
   - Use: `n` `n` `n` ... (next match)
   - Time: ____ seconds

3. **Jump to specific line number (e.g., line 100)**
   - Type: `:100` or `100G`
   - Time: ____ seconds

4. **Find all occurrences of a variable**
   - Position on variable
   - Type: `*` then `n` `n` `n`
   - Count: ____ occurrences
   - Time: ____ seconds

5. **Jump to matching bracket 20 times**
   - Use: `%` `%` `%` ...
   - Time: ____ seconds

6. **Navigate between class methods**
   - Use: `]]` (next method) and `[[` (previous)
   - Time: ____ seconds

**Goal: Complete all tasks in < 2 minutes**

---

## 🎯 Exercise 10: Final Boss Challenge

### The Ultimate Speed Test

**Setup**: Create a new file with this starter code:

```python
def process_data(data):
    results = []
    for item in data:
        if item > 0:
            results.append(item * 2)
    return results

input_data = [1, 2, 3, 4, 5]
output = process_data(input_data)
print(output)
```

### Tasks (Complete ALL in 10 minutes!)

1. **Refactor**: Add type hints
   ```python
   def process_data(data: list[int]) -> list[int]:
   ```

2. **Refactor**: Convert to list comprehension
   ```python
   results = [item * 2 for item in data if item > 0]
   ```

3. **Add**: Docstring to function
   ```python
   """Process data by doubling positive numbers."""
   ```

4. **Add**: Error handling
   ```python
   if not data:
       return []
   ```

5. **Add**: More test data
   ```python
   test_cases = [
       [1, 2, 3],
       [-1, 0, 1],
       [],
       [10, 20, 30]
   ]
   ```

6. **Add**: Loop to test all cases
   ```python
   for case in test_cases:
       result = process_data(case)
       print(f"Input: {case}, Output: {result}")
   ```

7. **Format**: Entire file
   - Use: `gg=G` (auto-indent all)

8. **Add**: Comments explaining each section

### Vim Commands You'll Need
```vim
O            " Add line above
ci(          " Change function params
ci[          " Change list content
]]           " Jump to next function
*            " Search word
cgn          " Change next match
.            " Repeat last change
V            " Select line
>            " Indent
<C-v>        " Visual block
ya{          " Yank function body
```

**Passing Score**: Complete 6/8 tasks in 10 minutes
**Master Score**: Complete 8/8 tasks in 8 minutes

---

## 📊 Score Your Speed

### Beginner Level
- ⭐ Exercise 1-2: < 5 minutes each
- ⭐ Exercise 3-4: < 10 minutes each
- **Total Time**: ~30 minutes

### Intermediate Level
- ⭐⭐ Exercise 1-4: < 15 minutes total
- ⭐⭐ Exercise 5-7: < 20 minutes total
- **Total Time**: ~35 minutes

### Advanced Level
- ⭐⭐⭐ Exercise 1-7: < 20 minutes total
- ⭐⭐⭐ Exercise 8-9: < 15 minutes total
- **Total Time**: ~35 minutes

### Master Level
- 🏆 All exercises: < 45 minutes total
- 🏆 Final Boss: 8/8 in 8 minutes
- 🏆 Can teach others!

---

## 🎓 Practice Tips

1. **Repeat Exercises**: Do each exercise 3 times to build muscle memory

2. **Track Progress**: Record your times and improve

3. **Focus on Accuracy**: Speed comes with accuracy, not rushing

4. **Use Cheat Sheet**: Keep [vim_shortcuts_cheatsheet.md](vim_shortcuts_cheatsheet.md) open

5. **Practice Daily**: 10 minutes daily > 1 hour weekly

6. **No Mouse**: Force yourself to use only keyboard

7. **Learn from Mistakes**: Note what slows you down

---

## 🏆 Completion Certificate

```
┌─────────────────────────────────────────────┐
│                                             │
│     🎓 VIM MASTERY CERTIFICATE 🎓          │
│                                             │
│          This certifies that               │
│                                             │
│         [Your Name Here]                    │
│                                             │
│      Has successfully completed             │
│      All 10 Vim Practice Exercises         │
│                                             │
│         Speed: _____ minutes                │
│         Date: _______________               │
│                                             │
│   🏆 Vim Master - Ready to Teach! 🏆       │
│                                             │
└─────────────────────────────────────────────┘
```

---

**Now go practice and become a Vim master! 🚀**

*Remember: Muscle memory beats memorization!*
