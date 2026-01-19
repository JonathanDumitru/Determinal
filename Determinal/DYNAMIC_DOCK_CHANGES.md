# Dynamic Dock Behavior - Implementation Summary

## ✅ Changes Implemented

### 1. Updated Toggle Shortcut: CMD+OPTION+` (CMD+ALT+`)
**Before:** CMD+` (two keys)
**After:** CMD+OPTION+` (three keys with Option/Alt)

**Rationale:**
- Avoids conflicts with system shortcuts and other apps
- More unique combination, less likely to trigger accidentally
- Option key is easy to reach alongside Command

### 2. Dynamic Dock Presence
**New Behavior:** App appears in Dock **only** when window is visible

**States:**
- **Window Visible** → Shows in Dock (`.regular` activation policy)
- **Window Hidden** → Hidden from Dock (`.accessory` activation policy)
- **Menu Bar Icon** → Always visible regardless of Dock state

## 📁 Files Modified

### DeterminalApp.swift

#### Line ~46: Updated keyboard shortcut
```swift
// Before:
.keyboardShortcut("`", modifiers: [.command])

// After:
.keyboardShortcut("`", modifiers: [.command, .option])
```

#### Line ~127: Updated global hotkey detection
```swift
// Before:
if event.modifierFlags.contains(.command) && 
   !event.modifierFlags.contains(.shift) &&
   event.charactersIgnoringModifiers == "`"

// After:
if event.modifierFlags.contains([.command, .option]) && 
   !event.modifierFlags.contains(.shift) &&
   event.charactersIgnoringModifiers == "`"
```

#### Line ~120: Initial state shows in Dock
```swift
func applicationDidFinishLaunching(_ notification: Notification) {
    // Start as menu bar app (no Dock icon initially)
    NSApp.setActivationPolicy(.accessory)
    
    // ... setup code ...
    
    DispatchQueue.main.async {
        // ... window setup ...
        
        // Show in Dock since window is initially visible
        NSApp.setActivationPolicy(.regular)
    }
}
```

#### Line ~279: Show in Dock when window appears
```swift
@objc func showTerminal() {
    guard let window = window else { return }
    
    // Show in Dock when window becomes visible
    NSApp.setActivationPolicy(.regular)
    
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    updateMenuBarTitle(show: false)
}
```

#### Line ~289: Hide from Dock when window hides
```swift
@objc func hideWindow() {
    guard let window = window else { return }
    window.orderOut(nil)
    
    // Hide from Dock when window is hidden
    NSApp.setActivationPolicy(.accessory)
    
    updateMenuBarTitle(show: true)
}
```

### ContentView.swift

#### Line ~372: Updated help command
```swift
addSystemMessage("Keyboard Shortcuts")
addOutputMessage("")
addOutputMessage("  ⌘ + Q             Hide window (app stays in menu bar)")
addOutputMessage("  ⌘ + ⌥ + `         Toggle terminal window")  // Changed!
addOutputMessage("  ⌘ + K             Clear terminal")
// ... other shortcuts ...

addSystemMessage("Menu Bar & Dock")
addOutputMessage("")
addOutputMessage("  • App appears in Dock when window is visible")
addOutputMessage("  • Hides from Dock when window is hidden")
addOutputMessage("  • Menu bar icon always available")
addOutputMessage("  • Right-click menu bar for quick access & quit")
```

#### Line ~836: Updated About window
```swift
FeatureRow(icon: "dock.rectangle", title: "Smart Dock Behavior", 
           description: "Shows in Dock only when window is visible")
FeatureRow(icon: "command", title: "Quick Toggle", 
           description: "⌘⌥` to show/hide from anywhere")
```

## 🎯 User Experience Improvements

### 1. Clean Dock Experience
```
Window Hidden:
┌─────────────────────────────┐
│  Dock: [Finder][Safari]...  │ ← No Determinal
└─────────────────────────────┘

Window Visible:
┌──────────────────────────────────────┐
│  Dock: [Finder][Safari][Determinal]  │ ← Appears!
└──────────────────────────────────────┘
```

**Benefits:**
- Less Dock clutter when not in use
- Visual indicator of app state
- Standard macOS app behavior when active
- Can CMD+TAB to app when window is visible

### 2. Smart Activation Policy Switching
```
App Launch → .accessory (hidden from Dock)
     ↓
Window Ready → .regular (appears in Dock)
     ↓
Hide Window → .accessory (disappears from Dock)
     ↓
Show Window → .regular (reappears in Dock)
```

### 3. Menu Bar Always Available
Regardless of Dock state, menu bar icon persists:
- Quick access even when hidden
- Right-click for all features
- Visual reminder that app is running

## 🎨 Visual States

### State 1: Window Visible
```
┌────────────────────────────────────────┐
│ Menu Bar: [▣] "Hide Terminal"          │
│ Dock: [..., Safari, Determinal]        │
│ Window: [Visible and Active]           │
│ Policy: .regular                       │
└────────────────────────────────────────┘

Actions Available:
- ⌘Q or ⌘⌥` to hide
- CMD+TAB includes Determinal
- Click Dock icon to focus
```

### State 2: Window Hidden
```
┌────────────────────────────────────────┐
│ Menu Bar: [▣] "Show Terminal"          │
│ Dock: [..., Safari] (no Determinal)    │
│ Window: [Hidden]                       │
│ Policy: .accessory                     │
└────────────────────────────────────────┘

Actions Available:
- ⌘⌥` to show
- Menu bar icon to access
- CMD+TAB does NOT include Determinal
```

### State 3: App Quit
```
┌────────────────────────────────────────┐
│ Menu Bar: [ ] (no icon)                │
│ Dock: [..., Safari] (no Determinal)    │
│ Window: [Terminated]                   │
│ Policy: N/A                            │
└────────────────────────────────────────┘

Restart required to use again
```

## ⌨️ Keyboard Shortcut Reference

| Shortcut | Action | Dock Behavior |
|----------|--------|---------------|
| ⌘⌥` | Toggle window | Appears/disappears |
| ⌘Q | Hide window | Disappears from Dock |
| ⌘K | Clear terminal | (No change) |
| ⌘I | Show status | (No change) |
| ⌘M | List models | (No change) |
| ⌘, | Settings | (No change) |

## 🎓 User Workflows

### Workflow 1: Quick Query (Clean Dock)
```
1. Dock is clean, no Determinal visible
   ↓
2. Press ⌘⌥` from any app
   ↓
3. Determinal appears in Dock AND as window
   ↓
4. Type your command, get response
   ↓
5. Press ⌘Q or ⌘⌥` to hide
   ↓
6. Determinal disappears from Dock
   ↓
7. Dock returns to clean state
```

### Workflow 2: Working with Terminal (Dock Icon)
```
1. Press ⌘⌥` to show Determinal
   ↓
2. Determinal appears in Dock
   ↓
3. Work in other apps (Safari, VS Code)
   ↓
4. Click Determinal in Dock to return
   OR
   Press ⌘⌥` to toggle
   OR  
   Use CMD+TAB to switch
   ↓
5. Window visible, Dock icon present
```

### Workflow 3: Background Monitoring
```
1. Start long-running AI task
   ↓
2. Press ⌘Q to hide window
   ↓
3. Dock icon disappears
   ↓
4. Work in other apps with clean Dock
   ↓
5. Check menu bar icon occasionally
   ↓
6. Press ⌘⌥` when ready to check
   ↓
7. Window and Dock icon reappear
```

## 💡 Design Decisions

### Why CMD+OPTION+` Instead of CMD+`?

1. **System Compatibility:** Many apps use CMD+` for cycling windows
2. **Conflict Avoidance:** Less likely to interfere with other shortcuts
3. **Intentional Gesture:** Three-key combo is deliberate, not accidental
4. **Option Key Location:** Easy to press alongside Command and backtick

### Why Dynamic Dock Behavior?

1. **Clean Workspace:** Dock isn't cluttered when app is hidden
2. **Visual Feedback:** Dock presence indicates window state
3. **Standard Behavior:** Apps typically show in Dock when active
4. **CMD+TAB Access:** Can switch to app normally when visible
5. **Menu Bar Fallback:** Icon always available for access

### Why Keep Menu Bar Icon Always?

1. **Quick Access:** Always one click away
2. **Status Indicator:** Shows app is running
3. **Quit Access:** Right-click to fully quit
4. **Consistent Location:** Always in same spot

## 🧪 Testing Checklist

- [ ] ⌘⌥` toggles window from any app
- [ ] Window visible → Dock icon appears
- [ ] Window hidden → Dock icon disappears  
- [ ] Menu bar icon always visible
- [ ] CMD+TAB includes app only when window visible
- [ ] Click Dock icon focuses window (when visible)
- [ ] ⌘Q hides window and removes from Dock
- [ ] Help command shows correct shortcuts
- [ ] About window reflects new behavior
- [ ] Right-click menu bar works in both states

## 🔄 Comparison with Previous Version

| Aspect | Previous (CMD+`) | New (CMD+ALT+`) |
|--------|------------------|------------------|
| Toggle Shortcut | ⌘` | ⌘⌥` |
| Dock Behavior | Always hidden | Dynamic |
| Window Visible | No Dock icon | Dock icon appears |
| Window Hidden | No Dock icon | No Dock icon |
| CMD+TAB | Never included | Included when visible |
| Menu Bar Icon | Always | Always |
| Dock Clicks | N/A | Works when visible |

## 📊 Benefits Summary

✅ **Cleaner Dock** - Only appears when needed
✅ **Visual State** - Dock presence indicates window state  
✅ **Better Integration** - Works with CMD+TAB when active
✅ **Reduced Conflicts** - ⌘⌥` less likely to clash
✅ **Standard macOS** - Behaves like normal apps when active
✅ **Menu Bar Backup** - Always accessible via menu bar
✅ **Flexible Usage** - Best of both worlds

## 🚀 Future Enhancements

Potential improvements:
- Preference to keep in Dock always (user option)
- Badge on Dock icon during inference
- Dock menu with quick actions (right-click Dock icon)
- Notification when long task completes
- Custom Dock icon states (active/idle)

---

## ✨ Summary

The app now intelligently manages its Dock presence:
- **⌘⌥`** for global toggle (Option + Command + Backtick)
- **Appears in Dock** when window is visible
- **Hides from Dock** when window is hidden
- **Menu bar icon** always available
- **Standard macOS behavior** when active

This provides a clean Dock experience while maintaining easy access and standard app switching when the window is visible. 🎉
