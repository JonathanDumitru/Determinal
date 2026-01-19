# Fixing Compilation Errors - Step by Step

## Current Errors
- Invalid redeclaration of 'LLMServiceFactory'
- Invalid redeclaration of 'LLMError'
- Ambiguous use of 'invalidURL' (multiple instances)

## Root Cause
These errors indicate duplicate type declarations exist in your project, likely from files that weren't properly added to or removed from the Xcode project.

## Solution Steps

### Step 1: Verify File Structure in Xcode

Open Xcode and check the Project Navigator (⌘+1). You should see these files:

**Core AI Files:**
- ✅ SafetyGuardian.swift
- ✅ SharedAITypes.swift ← **IMPORTANT: Check if this exists**
- ✅ LLMService.swift
- ✅ UnifiedAIService.swift
- ✅ SmartTerminAI.swift
- ✅ TerminAI.swift
- ✅ ContentView.swift

**Files to DELETE if they exist:**
- ❌ LLMTypes.swift ← Delete this if it exists in Xcode

### Step 2: Add Missing File to Xcode Project

If `SharedAITypes.swift` is NOT in your Xcode project:

1. In Finder, navigate to: `/Users/dev/Documents/Software/macOS/Determinal/Determinal/`
2. Find `SharedAITypes.swift`
3. Drag it into your Xcode project (Project Navigator)
4. In the dialog:
   - ✅ Check "Copy items if needed"
   - ✅ Check "Create groups"
   - ✅ Select your app target
   - Click "Finish"

### Step 3: Remove Duplicate File from Xcode

If `LLMTypes.swift` EXISTS in Xcode:

1. Select `LLMTypes.swift` in Project Navigator
2. Right-click → "Delete"
3. Choose "Move to Trash" (not just "Remove Reference")

### Step 4: Clean Build Folder

In Xcode:
1. Go to **Product** → **Clean Build Folder** (⇧⌘K)
2. Wait for it to complete

### Step 5: Rebuild Project

1. Press **⌘+B** to build
2. Check for any remaining errors

## If Errors Persist

### Option A: Search for Duplicate Definitions

In Xcode, press **⇧⌘F** (Find in Project) and search for:
1. `enum LLMError` - Should appear ONLY in `LLMService.swift`
2. `class LLMServiceFactory` - Should appear ONLY in `LLMService.swift`

If you find duplicates, delete them from the duplicate files.

### Option B: Manually Remove Duplicates

If you see errors pointing to specific files and line numbers:

1. Click on the error in Xcode's issue navigator
2. It will take you to the duplicate declaration
3. Delete the entire type declaration (the duplicate one)
4. Keep only the versions in:
   - `LLMService.swift` for `LLMError` and `LLMServiceFactory`
   - `SharedAITypes.swift` for `ModelSelector`, `ConversationContext`, `ContextTracker`
   - `SafetyGuardian.swift` for `SafetyGuardian` and `SafetyResult`

## Expected File Contents

### LLMService.swift should contain:
- `protocol LLMServiceProtocol`
- `class LLMService`
- `enum LLMError` ← **ONLY place this should exist**
- `enum LLMServiceType`
- `class LLMServiceFactory` ← **ONLY place this should exist**

### SharedAITypes.swift should contain:
- `struct ConversationContext`
- `class ContextTracker`
- `struct ModelSelector`

### NO file should have:
- Duplicate `LLMError`
- Duplicate `LLMServiceFactory`

## Verification

After fixing, your build should succeed with:
- ✅ 0 Errors
- ✅ 0 Warnings (ideally)

## Next Steps

Once the build succeeds:
1. Commit all changes to git
2. Push to GitHub (instructions in next section)
