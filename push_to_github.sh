#!/bin/bash

# Push Determinal to GitHub
# Make this file executable: chmod +x push_to_github.sh
# Run it: ./push_to_github.sh

set -e  # Exit on error

echo "🚀 Pushing Determinal to GitHub..."
echo ""

# Navigate to project directory
cd /Users/dev/Documents/Software/macOS/Determinal

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing Git repository..."
    git init
    git branch -M main
fi

# Check if remote exists
if git remote | grep -q "origin"; then
    echo "✓ Remote 'origin' already exists"
else
    echo "🔗 Adding remote repository..."
    git remote add origin https://github.com/JonathanDumitru/determinal.git
fi

echo ""
echo "📝 Staging all files..."
git add .

echo ""
echo "💾 Creating commit..."
git commit -m "Update: Determinal project with fixed compilation errors

- Fixed duplicate type declarations
- Added SharedAITypes.swift for shared AI types
- Organized LLMError and LLMServiceFactory in LLMService.swift
- Comprehensive safety system
- Multiple LLM backend support
- Documentation and guides included" || echo "No changes to commit"

echo ""
echo "☁️  Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo "🌐 View at: https://github.com/JonathanDumitru/determinal"
