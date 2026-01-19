# Determinal - Quick Reference (CMD+ALT+` with Dynamic Dock)

## 🎯 New Keyboard Shortcut

```
⌘ + ⌥ + `    Toggle Window (Command + Option/Alt + Backtick)
```

**How to press:**
1. Hold Command (⌘)
2. Hold Option (⌥) / Alt
3. Press Backtick (`)
4. Release all keys

## 📍 Dock Behavior

### Window Visible = Dock Icon Present
```
┌────────────────────────────────────────────┐
│                                            │
│   [Terminal Window Visible]               │
│                                            │
└────────────────────────────────────────────┘

Menu Bar: [▣] Hide Terminal
Dock:     [Finder][Safari][Determinal]  ← Present!
          
Can use: CMD+TAB, Dock click, ⌘⌥`
```

### Window Hidden = No Dock Icon
```
┌────────────────────────────────────────────┐
│                                            │
│   [Working in other apps]                 │
│                                            │
└────────────────────────────────────────────┘

Menu Bar: [▣] Show Terminal  ← Always there!
Dock:     [Finder][Safari]   ← No Determinal

Can use: ⌘⌥`, Menu bar icon
```

## ⌨️ All Keyboard Shortcuts

```
╔═══════════════════════════════════════════════╗
║         DETERMINAL SHORTCUTS                 ║
╠═══════════════════════════════════════════════╣
║  ⌘⌥`         Toggle window (show/hide)      ║
║  ⌘Q          Hide window                    ║
║  ⌘K          Clear terminal                 ║
║  ⌘I          Show status                    ║
║  ⌘M          List models                    ║
║  ⌘,          Settings                       ║
║  ⌘/          Help                           ║
╚═══════════════════════════════════════════════╝
```

## 🎬 Quick Usage Examples

### Example 1: Quick AI Question
```
Working in Safari
    ↓
Press ⌘⌥`
    ↓
Determinal appears
Dock icon appears
    ↓
Type: run "what is quantum entanglement?"
    ↓
Read response
    ↓
Press ⌘Q or ⌘⌥`
    ↓
Window hides
Dock icon disappears
    ↓
Back to Safari with clean Dock
```

### Example 2: Using Dock Icon
```
Press ⌘⌥` to show window
    ↓
Dock icon appears: [Determinal]
    ↓
Work in VS Code for a while
    ↓
Click Determinal in Dock
    ↓
Window comes to front
```

### Example 3: App Switching
```
Window is visible
    ↓
Press CMD+TAB
    ↓
Determinal appears in switcher!
    ↓
Select to switch to it
    ↓
(Only works when window is visible)
```

## 🎨 State Diagram

```
         ┌─────────────────┐
         │   APP LAUNCH    │
         └────────┬────────┘
                  │
                  ↓
         ┌─────────────────┐
         │ WINDOW VISIBLE  │
         │ Dock: ✓ Present │
         │ Menu: ✓ Present │
         └────────┬────────┘
                  │
       ⌘Q or ⌘⌥` │
                  ↓
         ┌─────────────────┐
         │ WINDOW HIDDEN   │
         │ Dock: ✗ Hidden  │
         │ Menu: ✓ Present │
         └────────┬────────┘
                  │
            ⌘⌥`  │
                  ↓
         (Back to Visible)
```

## 💡 Pro Tips

### Tip 1: Three Ways to Show Window
```
1. Press ⌘⌥` from anywhere
2. Click menu bar icon
3. Right-click menu bar → Show Terminal
```

### Tip 2: Four Ways to Hide Window
```
1. Press ⌘⌥` (toggle)
2. Press ⌘Q
3. Click window close button (⭕️)
4. Right-click menu bar → Hide Terminal
```

### Tip 3: Dock Icon Is Smart
```
Window shows → Dock icon appears
Window hides → Dock icon disappears

Clean Dock when not needed! ✨
```

### Tip 4: CMD+TAB When Active
```
When window is visible:
- ⌘+Tab includes Determinal
- Can switch like normal app

When window is hidden:
- ⌘+Tab skips Determinal
- Use ⌘⌥` or menu bar instead
```

### Tip 5: Menu Bar Always There
```
Even with Dock icon hidden:
- Menu bar icon [▣] always visible
- Right-click for full menu
- Quick access guaranteed
```

## 📊 Before & After Comparison

### Before (CMD+`)
```
Shortcut: ⌘`
Dock:     Never visible
Access:   Menu bar only
```

### After (CMD+ALT+`)
```
Shortcut: ⌘⌥`
Dock:     Visible when window is active
Access:   Menu bar + Dock (when active)
```

## 🎯 Remember

```
┌────────────────────────────────────────┐
│  ⌘⌥` = Toggle Window                  │
│  ⌘Q  = Hide Window                    │
│  [▣]  = Menu Bar (always available)   │
│  Dock = Smart (appears when active)   │
│                                        │
│  Right-click menu bar to QUIT         │
└────────────────────────────────────────┘
```

## 🆘 Troubleshooting

**Q: Why isn't ⌘⌥` working?**
- Make sure you're pressing all three keys: Command, Option, and Backtick
- Try pressing ⌘ and ⌥ first, then `
- Check if another app is using the same shortcut

**Q: Where did the Dock icon go?**
- It's hidden! This is normal when window is hidden
- Press ⌘⌥` to show window (and Dock icon)
- Menu bar icon is always available

**Q: How do I quit the app?**
- Right-click menu bar icon → "Quit Determinal"
- There's no keyboard shortcut (intentional)

**Q: Can I keep it in Dock always?**
- Not currently, but this is dynamic behavior
- Icon appears when window is active
- This keeps your Dock clean when not in use

---

## 📝 Quick Start Checklist

- [ ] Launch Determinal (appears in Dock with window)
- [ ] Press ⌘⌥` to hide (Dock icon disappears)
- [ ] Press ⌘⌥` to show (Dock icon reappears)
- [ ] Try clicking Dock icon when visible
- [ ] Try CMD+TAB when window is visible
- [ ] Hide window with ⌘Q (Dock icon disappears)
- [ ] Show with menu bar icon
- [ ] Type `help` to see all commands

**You're all set! Enjoy your smart Dock terminal! 🚀**
