//
//  StatusBarView.swift
//  Determinal
//
//  Bottom status bar showing model info and system resources
//

import SwiftUI

struct StatusBarView: View {
    let state: TerminalState
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Model status
            if let model = state.currentModel {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)
                    
                    Text(model.name)
                        .font(.uiXS)
                        .foregroundStyle(Color.App.textSecondary)
                }
            }
            
            Spacer()
            
            // System resources
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Memory usage
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "memorychip")
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: state.theme.colors.primaryDim))
                    
                    Text(memoryText)
                        .font(.uiXS)
                        .foregroundStyle(Color.App.textMuted)
                }
                
                // Tokens per second (if processing)
                if state.systemResources.tokensPerSec > 0 {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Image(systemName: "speedometer")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: state.theme.colors.primaryDim))
                        
                        Text(String(format: "%.1f tok/s", state.systemResources.tokensPerSec))
                            .font(.uiXS)
                            .foregroundStyle(Color.App.textMuted)
                    }
                }
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.md)
        .padding(.vertical, DesignTokens.Spacing.sm)
        .frame(height: DesignTokens.Layout.statusBarHeight)
        .background(Color.App.backgroundTertiary)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.App.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.hairline)
        }
    }
    
    private var statusColor: Color {
        switch state.modelStatus {
        case .ready:
            return Color.App.success
        case .loading:
            return Color.App.warning
        case .processing:
            return Color(hex: state.theme.colors.primary)
        case .error:
            return Color.App.error
        }
    }
    
    private var memoryText: String {
        let percentage = Int(state.systemResources.memoryPercentage)
        return "\(state.systemResources.memoryUsed)MB / \(state.systemResources.memoryTotal)MB (\(percentage)%)"
    }
}

#Preview {
    VStack {
        Spacer()
        StatusBarView(state: TerminalState())
    }
    .background(Color.App.backgroundPrimary)
}
