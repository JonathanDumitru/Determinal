//
//  SharedAITypes.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/19/26.
//

import Foundation

// MARK: - Conversation Context

struct ConversationContext {
    var history: [String] = []
}

// MARK: - Context Tracker

final class ContextTracker {
    private var prompts: [String] = []
    private let maxHistory = 10
    
    func addPrompt(_ prompt: String) async {
        prompts.append(prompt)
        if prompts.count > maxHistory {
            prompts.removeFirst()
        }
    }
    
    func getCurrentContext() async -> ConversationContext {
        ConversationContext(history: prompts)
    }
    
    func clear() async {
        prompts.removeAll()
    }
}

// MARK: - Model Selector

struct ModelSelector {
    enum Target: String {
        case small = "llama2"
        case medium = "codellama"
        case large = "mixtral"
        case smallLocal = "termin-small"
        case mediumLocal = "termin-medium"
        case largeRemote = "termin-large"
    }
    
    struct Capability {
        let isAppleSilicon: Bool
        let physicalMemoryGB: Int
        
        static func current() -> Capability {
            let bytes = ProcessInfo.processInfo.physicalMemory
            let gb = Int((Double(bytes) / (1024.0 * 1024.0 * 1024.0)).rounded(.down))
            return Capability(isAppleSilicon: ProcessInfo.processInfo.isAppleSilicon, physicalMemoryGB: gb)
        }
        
        var tier: Int {
            switch physicalMemoryGB {
            case ..<9: return 1
            case 9...16: return 2
            default: return 3
            }
        }
    }
    
    func selectModel(for prompt: String, requested: String?) -> String {
        // Respect explicit request
        if let requested, !requested.isEmpty, requested.lowercased() != "auto", requested.lowercased() != "default" {
            return requested
        }
        
        let caps = Capability.current()
        let length = prompt.count
        let tier = caps.tier
        
        // Heuristic by capability tier and prompt length
        if caps.isAppleSilicon {
            switch tier {
            case 1: // <= 8GB
                return Target.small.rawValue
            case 2: // 9-16GB
                return length < 2000 ? Target.small.rawValue : Target.medium.rawValue
            default: // >16GB
                return length < 500 ? Target.small.rawValue : 
                       length < 2000 ? Target.medium.rawValue : Target.large.rawValue
            }
        } else {
            return Target.small.rawValue
        }
    }
}

private extension ProcessInfo {
    var isAppleSilicon: Bool {
        #if arch(arm64)
        return true
        #else
        return false
        #endif
    }
}
