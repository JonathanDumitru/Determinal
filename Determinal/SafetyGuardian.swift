//
//  SafetyGuardian.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/16/26.
//

import Foundation

// MARK: - Safety Result

struct SafetyResult {
    let isSafe: Bool
    let warningMessage: String
}

// MARK: - Safety Guardian

/// Comprehensive safety system to protect users and their devices
actor SafetyGuardian {
    
    // MARK: - Initialization
    
    init() {
        // Empty initializer for actor
    }
    
    // MARK: - Dangerous Patterns
    
    private let dangerousCommands = [
        // File system destruction
        "rm -rf /", "rm -rf /*", "rm -rf ~", "rm -rf *",
        "del /f /s /q", "format", "mkfs", "dd if=/dev/zero",
        
        // System manipulation
        "sudo rm", "sudo chmod -R 000", "chmod 000 /",
        "kill -9 1", "killall -9", "pkill -9",
        
        // Disk operations
        "> /dev/sda", "> /dev/hda", "shred",
        
        // Malicious scripts
        ":(){ :|:& };:", "wget | sh", "curl | bash",
        
        // System configuration
        "rm /etc/", "rm /bin/", "rm /usr/",
        "mv /bin /dev/null", "ln -s /dev/null"
    ]
    
    private let dangerousKeywords = [
        "delete system", "format disk", "erase hard drive",
        "destroy filesystem", "wipe device", "remove all files",
        "factory reset", "delete everything"
    ]
    
    private let protectedPaths = [
        "/System", "/Library", "/bin", "/sbin", "/usr",
        "/etc", "/var", "/tmp", "/boot", "/dev",
        "C:\\Windows", "C:\\Program Files"
    ]
    
    // MARK: - Safety Checks
    
    func validatePrompt(_ prompt: String) -> SafetyResult {
        let lower = prompt.lowercased()
        
        // Check for dangerous commands
        for command in dangerousCommands {
            if lower.contains(command) {
                return SafetyResult(
                    isSafe: false,
                    warningMessage: createDangerousCommandWarning(command: command)
                )
            }
        }
        
        // Check for dangerous keywords
        for keyword in dangerousKeywords {
            if lower.contains(keyword) {
                return SafetyResult(
                    isSafe: false,
                    warningMessage: createDangerousIntentWarning(intent: keyword)
                )
            }
        }
        
        // Check for protected paths
        for path in protectedPaths {
            if prompt.contains(path) && (lower.contains("delete") || lower.contains("remove")) {
                return SafetyResult(
                    isSafe: false,
                    warningMessage: createProtectedPathWarning(path: path)
                )
            }
        }
        
        return SafetyResult(isSafe: true, warningMessage: "")
    }
    
    func validateOutput(_ output: String) -> SafetyResult {
        let lower = output.lowercased()
        
        // Check if output contains dangerous code
        let dangerousCodePatterns = [
            "rm -rf", "sudo rm", "format", "delete system",
            "chmod 000", "kill -9 1"
        ]
        
        for pattern in dangerousCodePatterns {
            if lower.contains(pattern) && !lower.contains("⚠️") && !lower.contains("warning") {
                return SafetyResult(
                    isSafe: false,
                    warningMessage: """
                    🛡️ **Termin Safety Block**
                    
                    I detected potentially dangerous content in my response that could harm your system.
                    For your protection, this output has been blocked.
                    
                    If you're learning about system commands:
                    • I can explain them safely without running them
                    • I'll provide educational context with warnings
                    • I'll suggest safe alternatives when possible
                    
                    Your safety is my priority. Please ask again with more context about what you're trying to learn.
                    """
                )
            }
        }
        
        return SafetyResult(isSafe: true, warningMessage: "")
    }
    
    // MARK: - Warning Messages
    
    private func createDangerousCommandWarning(command: String) -> String {
        """
        🛡️ **TERMIN SAFETY ALERT**
        
        I detected a potentially dangerous command: `\(command)`
        
        **This command could:**
        • Delete critical system files
        • Make your system unbootable
        • Cause permanent data loss
        • Damage your operating system
        
        **I cannot and will not:**
        ✗ Execute dangerous system commands
        ✗ Provide instructions for destructive operations
        ✗ Help with commands that could harm your device
        
        **If you're learning:**
        ✓ I can explain what commands do safely
        ✓ I can teach about system administration
        ✓ I can show safe alternatives
        
        **Safety Resources:**
        • Always backup your data
        • Test commands in virtual machines
        • Use version control
        • Learn in sandbox environments
        
        How can I help you learn safely instead?
        """
    }
    
    private func createDangerousIntentWarning(intent: String) -> String {
        """
        🛡️ **TERMIN SAFETY WARNING**
        
        Your request involves: "\(intent)"
        
        This could potentially harm your system or data. 
        
        **For your safety:**
        • I won't provide instructions for destructive operations
        • I can explain concepts educationally
        • I can suggest safe alternatives
        
        **If you need to:**
        • Delete files → Use proper file management with backups
        • Reset system → Use official system preferences
        • Learn about security → I can explain safely
        
        What specific problem are you trying to solve? I'll help you find a safe solution.
        """
    }
    
    private func createProtectedPathWarning(path: String) -> String {
        """
        🛡️ **TERMIN PROTECTION ACTIVE**
        
        You mentioned modifying: `\(path)`
        
        This is a protected system path. Modifying it could:
        • Break your operating system
        • Prevent your system from booting
        • Cause application failures
        • Require system reinstallation
        
        **Protected Locations:**
        These directories are essential for system operation and should never be manually modified.
        
        **If you need to:**
        • Install software → Use official installers
        • Modify settings → Use System Preferences
        • Clean up space → Use Disk Utility
        
        **Safe Alternatives:**
        • Work in your home directory (~/Documents, ~/Downloads)
        • Use application-specific folders
        • Create test directories for experiments
        
        How can I help you accomplish your goal safely?
        """
    }
    
    func getDangerousCommandWarning(for prompt: String) -> String {
        """
        🛡️ **TERMIN SAFETY SYSTEM**
        
        I detected a request that could be dangerous to your system.
        
        **What I'm here for:**
        ✓ Teaching programming safely
        ✓ Explaining concepts
        ✓ Generating safe code
        ✓ Debugging assistance
        ✓ Best practices
        
        **What I protect you from:**
        ✗ Destructive system commands
        ✗ Data loss operations
        ✗ Security vulnerabilities
        ✗ System-breaking code
        
        **Your Safety is Paramount**
        
        Termin is designed to help you learn and code safely. I'll never suggest actions that could harm your device or data.
        
        Let me help you with something safe and productive instead!
        """
    }
}
