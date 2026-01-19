//
//  DeterminalApp.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import SwiftUI
import AppKit

@main
struct DeterminalApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Hide from Dock - runs as menubar app only
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HideWindow"))) { _ in
                    // Hide window when CMD+Q is pressed
                    if let window = NSApp.windows.first {
                        window.orderOut(nil)
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 1200, height: 800)
        .commands {
            // Replace default File menu
            CommandGroup(replacing: .newItem) { }
            
            // Custom app commands - override CMD+Q behavior
            CommandGroup(replacing: .appTermination) {
                Button("Hide Determinal") {
                    NotificationCenter.default.post(name: NSNotification.Name("HideWindow"), object: nil)
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
            
            // Custom Terminal menu
            CommandMenu("Terminal") {
                Button("Show/Hide Terminal") {
                    NotificationCenter.default.post(name: NSNotification.Name("ToggleTerminal"), object: nil)
                }
                .keyboardShortcut("`", modifiers: [.command, .shift])
                
                Divider()
                
                Button("Clear Terminal") {
                    NotificationCenter.default.post(name: NSNotification.Name("ClearTerminal"), object: nil)
                }
                .keyboardShortcut("k", modifiers: [.command])
                
                Divider()
                
                Button("Show Status") {
                    NotificationCenter.default.post(name: NSNotification.Name("ExecuteCommand"), object: "status")
                }
                .keyboardShortcut("i", modifiers: [.command])
                
                Button("List Models") {
                    NotificationCenter.default.post(name: NSNotification.Name("ExecuteCommand"), object: "models")
                }
                .keyboardShortcut("m", modifiers: [.command])
                
                Divider()
                
                Button("Settings...") {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowSettings"), object: nil)
                }
                .keyboardShortcut(",", modifiers: [.command])
            }
            
            // Enhanced Help menu
            CommandGroup(replacing: .help) {
                Button("Determinal Help") {
                    NotificationCenter.default.post(name: NSNotification.Name("ExecuteCommand"), object: "help")
                }
                .keyboardShortcut("/", modifiers: [.command])
                
                Button("View Documentation") {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowDocumentation"), object: nil)
                }
                
                Divider()
                
                Link("View on GitHub", destination: URL(string: "https://github.com")!)
                Link("Report an Issue", destination: URL(string: "https://github.com/issues")!)
                
                Divider()
                
                Button("About Determinal") {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowAbout"), object: nil)
                }
            }
            
            // Enhanced app menu
            CommandGroup(replacing: .appInfo) {
                Button("About Determinal") {
                    NotificationCenter.default.post(name: NSNotification.Name("ShowAbout"), object: nil)
                }
            }
        }
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Start as menu bar app (no Dock icon initially)
        NSApp.setActivationPolicy(.accessory)
        
        // Create menu bar item with custom icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "terminal.fill", accessibilityDescription: "Determinal")
            button.action = #selector(toggleTerminal)
            button.target = self
        }
        
        // Create right-click menu
        setupStatusBarMenu()
        
        // Setup global hotkey (⌘⇧` to toggle)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains([.command, .shift]) && 
               event.charactersIgnoringModifiers == "`" {
                self.toggleTerminal()
            }
        }
        
        // Listen for notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTerminal),
            name: NSNotification.Name("ToggleTerminal"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideWindow),
            name: NSNotification.Name("HideWindow"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDocumentation),
            name: NSNotification.Name("ShowDocumentation"),
            object: nil
        )
        
        // Get the main window
        DispatchQueue.main.async {
            self.window = NSApp.windows.first
            self.window?.level = .floating
            self.window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            
            // Override window's close button to hide instead of quit
            self.window?.delegate = self
            
            // Show in Dock since window is initially visible
            NSApp.setActivationPolicy(.regular)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Don't quit when window closes - keep running in menu bar
        return false
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Show window when user clicks Dock icon (if visible)
        if !flag {
            showTerminal()
        }
        return true
    }
    
    private func setupStatusBarMenu() {
        let menu = NSMenu()
        
        // Show/Hide option
        let showHideItem = NSMenuItem(
            title: "Show Terminal",
            action: #selector(toggleTerminal),
            keyEquivalent: ""
        )
        showHideItem.target = self
        menu.addItem(showHideItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quick actions
        let clearItem = NSMenuItem(
            title: "Clear Terminal",
            action: #selector(clearTerminal),
            keyEquivalent: "k"
        )
        clearItem.keyEquivalentModifierMask = .command
        clearItem.target = self
        menu.addItem(clearItem)
        
        let statusMenuItem = NSMenuItem(
            title: "Show Status",
            action: #selector(showStatus),
            keyEquivalent: "i"
        )
        statusMenuItem.keyEquivalentModifierMask = .command
        statusMenuItem.target = self
        menu.addItem(statusMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings and About
        let settingsItem = NSMenuItem(
            title: "Settings...",
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        settingsItem.keyEquivalentModifierMask = .command
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        let docsItem = NSMenuItem(
            title: "Documentation",
            action: #selector(showDocumentation),
            keyEquivalent: ""
        )
        docsItem.target = self
        menu.addItem(docsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let aboutItem = NSMenuItem(
            title: "About Determinal",
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit option (fully quits the app) - only accessible from menu bar
        let quitItem = NSMenuItem(
            title: "Quit Determinal",
            action: #selector(quit),
            keyEquivalent: ""
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc func toggleTerminal() {
        guard let window = window else { return }
        
        if window.isVisible {
            hideWindow()
            updateMenuBarTitle(show: true)
        } else {
            showTerminal()
            updateMenuBarTitle(show: false)
        }
    }
    
    @objc func showTerminal() {
        guard let window = window else { return }
        
        // Show in Dock when window becomes visible
        NSApp.setActivationPolicy(.regular)
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        updateMenuBarTitle(show: false)
    }
    
    @objc func hideWindow() {
        guard let window = window else { return }
        window.orderOut(nil)
        
        // Hide from Dock when window is hidden
        NSApp.setActivationPolicy(.accessory)
        
        updateMenuBarTitle(show: true)
    }
    
    @objc func clearTerminal() {
        NotificationCenter.default.post(name: NSNotification.Name("ClearTerminal"), object: nil)
    }
    
    @objc func showStatus() {
        NotificationCenter.default.post(name: NSNotification.Name("ExecuteCommand"), object: "status")
        showTerminal()
    }
    
    @objc func openSettings() {
        NotificationCenter.default.post(name: NSNotification.Name("ShowSettings"), object: nil)
        showTerminal()
    }
    
    @objc func showAbout() {
        NotificationCenter.default.post(name: NSNotification.Name("ShowAbout"), object: nil)
        showTerminal()
    }
    
    @objc func showDocumentation() {
        if let url = Bundle.main.url(forResource: "COMMANDS", withExtension: "md") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc func quit() {
        NSApp.terminate(nil)
    }
    
    private func updateMenuBarTitle(show: Bool) {
        guard let menu = statusItem?.menu else { return }
        if let firstItem = menu.items.first {
            firstItem.title = show ? "Show Terminal" : "Hide Terminal"
        }
    }
}

// MARK: - Window Delegate

extension AppDelegate: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // When user clicks close button, hide window instead of quitting
        hideWindow()
        return false
    }
    
    func windowWillClose(_ notification: Notification) {
        // This prevents the window from actually closing
        // The app continues running in the menu bar
    }
}


