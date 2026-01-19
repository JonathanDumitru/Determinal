//
//  StatusBarView.swift
//  Determinal
//
//  Status bar showing system resources and model status
//

import SwiftUI

struct StatusBarView: View {
    let resources: SystemResources
    let modelStatus: ModelStatus
    let theme: AppTheme
    
    var body: some View {
        HStack(spacing: Spacing.lg) {
            // Tokens per second
            StatusItem(
                icon: "cpu",
                label: "\(String(format: "%.1f", resources.tokensPerSec)) tokens/s",
                theme: theme
            )
            
            // Memory usage
            StatusItem(
                icon: "memorychip",
                label: "\(resources.memoryUsed)MB / \(resources.memoryTotal)MB",
                theme: theme
            )
            
            // Model status
            StatusItem(
                icon: "waveform",
                label: modelStatus.rawValue,
                theme: theme,
                isAnimated: modelStatus == .inferencing
            )
            
            Spacer()
        }
        .padding(.horizontal, Spacing.base)
        .padding(.vertical, Spacing.sm)
        .background(Color.appBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.appBorder)
                .frame(height: BorderWidth.standard)
        }
    }
}

// MARK: - Status Item

private struct StatusItem: View {
    let icon: String
    let label: String
    let theme: AppTheme
    var isAnimated: Bool = false
    
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: IconSize.xs))
                .foregroundStyle(Color.appTextTertiary)
            
            Text(label)
                .font(.appMonoSmall)
                .foregroundStyle(
                    isAnimated ? theme.primary : Color.appTextSecondary
                )
        }
        .opacity(isAnimated ? 0.7 : 1.0)
        .animation(
            isAnimated ?
                .easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                .default,
            value: isAnimated
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        StatusBarView(
            resources: SystemResources(
                memoryUsed: 3825,
                memoryTotal: 16384,
                tokensPerSec: 42.5
            ),
            modelStatus: .inferencing,
            theme: .matrix
        )
        
        Spacer()
    }
    .background(Color.appSurface)
}
