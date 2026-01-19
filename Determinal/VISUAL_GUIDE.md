# Determinal - Visual User Guide

## 🎯 Three Simple Actions

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│         1. TOGGLE WINDOW     2. HIDE WINDOW        │
│              ⌘ + `                ⌘ + Q            │
│                                                     │
│         3. QUIT APP (Right-click menu bar)         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 1️⃣ Toggle Window with ⌘`

### From Any Application

```
┌──────────────────────────────────┐
│   Working in Safari/Chrome       │
│   ┌──────────────────┐          │
│   │  [Web Page]      │          │
│   │                  │          │
│   └──────────────────┘          │
└──────────────────────────────────┘
                ⬇️
         Press  ⌘ + `
                ⬇️
┌──────────────────────────────────┐
│   Determinal Appears!            │
│   ┌──────────────────┐          │
│   │  ~/projects ❯    │          │
│   │  [Terminal]      │          │
│   └──────────────────┘          │
└──────────────────────────────────┘
                ⬇️
    Press  ⌘ + `  again
                ⬇️
┌──────────────────────────────────┐
│   Back to Safari                 │
│   (Determinal hidden)            │
│   Menu Bar: [▣] ready            │
└──────────────────────────────────┘
```

**Key Points:**
- Works from **any app**
- **Toggle** behavior: show if hidden, hide if visible
- **No SHIFT needed** - just ⌘`
- Window position and history preserved

---

## 2️⃣ Hide Window with ⌘Q

### Standard Hide Behavior

```
┌──────────────────────────────────┐
│   Determinal Window Active       │
│   ┌──────────────────┐          │
│   │  ~/projects ❯    │          │
│   │  run "help me"   │          │
│   │  [AI Response]   │          │
│   └──────────────────┘          │
└──────────────────────────────────┘
                ⬇️
         Press  ⌘ + Q
                ⬇️
┌──────────────────────────────────┐
│   Window Disappears              │
│   Menu Bar: [▣] still running    │
│                                  │
│   App continues in background    │
│   All data preserved             │
└──────────────────────────────────┘
```

**Key Points:**
- Window hides **but app keeps running**
- Menu bar icon [▣] remains visible
- Press ⌘` to show again
- Alternative to using ⌘` for hiding

---

## 3️⃣ Quit App via Menu Bar

### Right-Click Menu Bar Icon

```
┌─────────────────────────────────┐
│  [▣] ← Right-click this icon    │
└─────────────────────────────────┘
                ⬇️
┌──────────────────────────────────┐
│  Show Terminal                   │
│  ────────────────────────        │
│  Clear Terminal          ⌘K      │
│  Show Status             ⌘I      │
│  ────────────────────────        │
│  Settings...             ⌘,      │
│  Documentation                   │
│  ────────────────────────        │
│  About Determinal                │
│  ────────────────────────        │
│  Quit Determinal         ← Click │
└──────────────────────────────────┘
                ⬇️
┌──────────────────────────────────┐
│   App Fully Quits                │
│   Menu Bar Icon Disappears       │
│   All windows closed             │
└──────────────────────────────────┘
```

**Key Points:**
- **Only way** to fully quit the app
- No keyboard shortcut (intentional!)
- Prevents accidental quits
- Menu bar icon disappears when quit

---

## 🎨 Window States Diagram

```
┌─────────────────────────────────────────────────────┐
│                   WINDOW LIFECYCLE                  │
└─────────────────────────────────────────────────────┘

    ╔════════════╗
    ║   LAUNCH   ║
    ║    APP     ║
    ╚════════════╝
          │
          ↓
    ┌──────────────┐
    │   VISIBLE    │←──────────────────┐
    │   & ACTIVE   │                   │
    └──────────────┘                   │
          │                            │
          │  ⌘Q  or  ⌘`               │
          ↓                            │
    ┌──────────────┐                   │
    │    HIDDEN    │                   │
    │ (Menu Bar ▣) │                   │
    └──────────────┘                   │
          │                            │
          │  ⌘`                        │
          └────────────────────────────┘
          │
          │  Right-click → Quit
          ↓
    ╔════════════╗
    ║    QUIT    ║
    ║  (No Icon) ║
    ╚════════════╝
```

---

## 📍 Menu Bar States

### Window Visible
```
Menu Bar: [▣] Show Terminal → Hide Terminal
                  ─────
          Click to: Hide the window
          Same as:  ⌘Q or ⌘`
```

### Window Hidden
```
Menu Bar: [▣] Show Terminal → Show Terminal
                  ─────
          Click to: Show the window
          Same as:  ⌘`
```

### App Quit
```
Menu Bar: [ empty - no icon ]

          App is not running
          Launch to restart
```

---

## ⌨️ Keyboard Shortcut Flowchart

```
                ┌─────────────────────┐
                │   Working Anywhere  │
                └─────────────────────┘
                          │
                    ┌─────┴─────┐
                    │           │
              Press ⌘`    Press ⌘Q
                    │           │
                    ↓           ↓
            ┌───────────┐   ┌───────────┐
            │  TOGGLE   │   │   HIDE    │
            │  Window   │   │   Window  │
            └───────────┘   └───────────┘
                    │           │
                    └─────┬─────┘
                          ↓
                  ┌───────────────┐
                  │ App Running   │
                  │ in Menu Bar   │
                  └───────────────┘
                          │
              Right-click menu bar
                          │
                  ┌───────┴───────┐
                  │               │
            Click Show      Click Quit
                  │               │
                  ↓               ↓
          ┌───────────┐   ┌───────────┐
          │  VISIBLE  │   │   QUIT    │
          │   Again   │   │   App     │
          └───────────┘   └───────────┘
```

---

## 🎯 Common Scenarios

### Scenario 1: Quick AI Question
```
1. Safari open, reading article
   ↓
2. Press ⌘`
   ↓  
3. Determinal appears over Safari
   ↓
4. Type: run "summarize this article"
   ↓
5. Read AI response
   ↓
6. Press ⌘` or ⌘Q
   ↓
7. Back to Safari, Determinal ready in menu bar
```

### Scenario 2: Background Processing
```
1. Start long AI task in Determinal
   ↓
2. Press ⌘Q to hide
   ↓
3. Work in other apps (Email, Slack)
   ↓
4. Press ⌘` to check progress
   ↓
5. Task complete! Read results
   ↓
6. Press ⌘Q again to hide
```

### Scenario 3: End of Day
```
1. Done working for the day
   ↓
2. Right-click menu bar icon [▣]
   ↓
3. Click "Quit Determinal"
   ↓
4. App fully quits, icon disappears
   ↓
5. Tomorrow: Launch app fresh
```

---

## 🎨 Visual Cheat Sheet

```
╔═══════════════════════════════════════════════════╗
║              DETERMINAL AT A GLANCE              ║
╠═══════════════════════════════════════════════════╣
║                                                   ║
║  ⌘ + `         │  Toggle Window (Show/Hide)      ║
║  ────────────────────────────────────────────── ║
║  ⌘ + Q         │  Hide Window Only               ║
║  ────────────────────────────────────────────── ║
║  [▣] Right-Click │  Access All Features          ║
║                 │  • Show/Hide                   ║
║                 │  • Quick Actions               ║
║                 │  • Settings & Docs             ║
║                 │  • QUIT APP ← Only Way         ║
║  ────────────────────────────────────────────── ║
║  ⌘ + K         │  Clear Terminal                 ║
║  ⌘ + I         │  Show Status                    ║
║  ⌘ + M         │  List Models                    ║
║  ⌘ + ,         │  Settings                       ║
║  ⌘ + /         │  Help                           ║
║                                                   ║
╚═══════════════════════════════════════════════════╝

        REMEMBER: No keyboard shortcut quits!
           Use menu bar to quit completely.
```

---

## 💡 Quick Tips

### Tip #1: One-Key Toggle
```
Old: ⌘ + SHIFT + `  (3 keys)
New: ⌘ + `          (2 keys) ✨ Easier!
```

### Tip #2: Two Ways to Hide
```
Method 1: ⌘Q       ← Standard hide
Method 2: ⌘`       ← Toggle (hides if visible)
Both do the same thing when window is visible!
```

### Tip #3: No Accidental Quits
```
❌ Can't accidentally press a shortcut
✅ Must consciously right-click & select quit
   This protects your work!
```

### Tip #4: Global Access
```
⌘` works from ANY app:
• Safari      → Press ⌘` → Determinal!
• VS Code     → Press ⌘` → Determinal!
• Slack       → Press ⌘` → Determinal!
• Full Screen → Press ⌘` → Determinal!
```

### Tip #5: Window Close Button
```
Clicking X (⭕️) = Same as ⌘Q
│
└─→ Hides window, doesn't quit
    App stays in menu bar
```

---

## 🎓 Learning Path

### Day 1: Basic Usage
- Launch app
- Type `help` to see commands
- Try ⌘` to hide/show
- Right-click menu bar to explore

### Day 2: Keyboard Flow
- Practice ⌘` from different apps
- Use ⌘Q when you want to hide
- Learn ⌘K, ⌘I, ⌘M shortcuts

### Week 1: Muscle Memory
- ⌘` becomes automatic
- Right-click menu is second nature
- Never think about it anymore! 🎉

---

**You're ready to use Determinal like a pro! 🚀**

For detailed command list, type `help` in the terminal.
For settings and preferences, press ⌘, or right-click menu bar.
