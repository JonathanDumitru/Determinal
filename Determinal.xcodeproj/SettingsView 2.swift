//
//  SettingsView.swift
//  Determinal
//
//  Settings modal for model and theme selection
//

import SwiftUI

struct SettingsView: View {
    @Binding var state: TerminalState
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Modal content
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                        // Model selection
                        modelSelectionSection
                        
                        // Theme selection
                        themeSelectionSection
                        
                        // System info
                        systemInfoSection
                    }
                    .padding(DesignTokens.Spacing.xl)
                }
                
                // Footer
                footerView
            }
            .frame(width: 700, height: 600)
            .background(Color.neutral950)
            .cornerRadius(DesignTokens.CornerRadius.xl)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xl)
                    .stroke(Color.neutral800, lineWidth: DesignTokens.BorderWidth.standard)
            )
            .designShadow(DesignTokens.Shadow.strong)
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            HStack(spacing: DesignTokens.Spacing.sm) {
                Image(systemName: "gearshape")
                    .font(.system(size: DesignTokens.IconSize.md))
                    .foregroundStyle(Color(hex: state.theme.colors.primary))
                
                Text("SETTINGS")
                    .font(.uiLGMedium)
                    .uppercaseLabel()
                    .foregroundStyle(Color.App.textPrimary)
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: DesignTokens.IconSize.md))
                    .foregroundStyle(Color.App.textMuted)
            }
            .buttonStyle(PlainButtonHoverStyle(theme: state.theme))
        }
        .padding(DesignTokens.Spacing.xl)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.neutral800)
                .frame(height: DesignTokens.BorderWidth.hairline)
        }
    }
    
    private var modelSelectionSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("AI MODEL")
                .font(.uiSMMedium)
                .uppercaseLabel()
                .foregroundStyle(Color(hex: state.theme.colors.primary))
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(availableModels.filter { $0.isDownloaded }) { model in
                    ModelSelectionRow(
                        model: model,
                        isSelected: state.currentModel?.id == model.id,
                        theme: state.theme
                    ) {
                        state.switchModel(to: model)
                    }
                }
            }
        }
    }
    
    private var themeSelectionSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("THEME")
                .font(.uiSMMedium)
                .uppercaseLabel()
                .foregroundStyle(Color(hex: state.theme.colors.primary))
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: DesignTokens.Spacing.md
            ) {
                ForEach(availableThemes) { theme in
                    ThemeSelectionCard(
                        theme: theme,
                        isSelected: state.theme.id == theme.id
                    ) {
                        state.switchTheme(to: theme)
                    }
                }
            }
        }
    }
    
    private var systemInfoSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("SYSTEM INFORMATION")
                .font(.uiSMMedium)
                .uppercaseLabel()
                .foregroundStyle(Color(hex: state.theme.colors.primary))
            
            VStack(spacing: 0) {
                SystemInfoRow(label: "Platform", value: "macOS (simulated)")
                Divider().background(Color.neutral800)
                SystemInfoRow(label: "Architecture", value: "arm64")
                Divider().background(Color.neutral800)
                SystemInfoRow(label: "Backend", value: "llama.cpp")
                Divider().background(Color.neutral800)
                SystemInfoRow(label: "Version", value: "1.0.0")
                Divider().background(Color.neutral800)
                SystemInfoRow(
                    label: "Total Memory",
                    value: "\(state.systemResources.memoryTotal)MB"
                )
            }
            .background(Color.neutral900)
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(Color.neutral800, lineWidth: DesignTokens.BorderWidth.standard)
            )
        }
    }
    
    private var footerView: some View {
        HStack {
            Spacer()
            
            Button("Close") {
                onDismiss()
            }
            .buttonStyle(PrimaryButtonStyle(theme: state.theme))
        }
        .padding(DesignTokens.Spacing.xl)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.neutral800)
                .frame(height: DesignTokens.BorderWidth.hairline)
        }
    }
}

// MARK: - Model Selection Row

struct ModelSelectionRow: View {
    let model: AIModel
    let isSelected: Bool
    let theme: Theme
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(model.name)
                        .font(.monoMDBold)
                        .foregroundStyle(
                            isSelected ?
                            Color(hex: theme.colors.primary) :
                            Color.App.textPrimary
                        )
                    
                    HStack(spacing: DesignTokens.Spacing.md) {
                        Text("Type: \(model.type)")
                        Text("Size: \(model.size)MB")
                        Text("Format: \(model.quantization)")
                    }
                    .font(.uiXS)
                    .foregroundStyle(Color.App.textMuted)
                }
                
                Spacer()
                
                if isSelected {
                    Text("ACTIVE")
                        .font(.uiXS)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(hex: theme.colors.primary))
                        .padding(.horizontal, DesignTokens.Spacing.sm)
                        .padding(.vertical, DesignTokens.Spacing.xs)
                        .background(
                            Color(hex: theme.colors.primary).opacity(0.2)
                        )
                        .cornerRadius(DesignTokens.CornerRadius.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                                .stroke(
                                    Color(hex: theme.colors.primaryDim).opacity(0.8),
                                    lineWidth: DesignTokens.BorderWidth.standard
                                )
                        )
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                isSelected ?
                Color.neutral800.opacity(0.5) :
                Color.neutral900
            )
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        isSelected ?
                        Color.neutral600 :
                        Color.neutral800,
                        lineWidth: DesignTokens.BorderWidth.standard
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Theme Selection Card

struct ThemeSelectionCard: View {
    let theme: Theme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Text(theme.name)
                        .font(.monoMDBold)
                        .foregroundStyle(Color.App.textPrimary)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("ACTIVE")
                            .font(.uiXS)
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: theme.colors.primary))
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, DesignTokens.Spacing.xxs)
                            .background(
                                Color(hex: theme.colors.primary).opacity(0.2)
                            )
                            .cornerRadius(DesignTokens.CornerRadius.sm)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                                    .stroke(
                                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                                        lineWidth: DesignTokens.BorderWidth.standard
                                    )
                            )
                    }
                }
                
                // Color preview
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ColorSwatch(hex: theme.colors.primary)
                    ColorSwatch(hex: theme.colors.primaryDim)
                    ColorSwatch(hex: theme.colors.primaryBright)
                }
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                isSelected ?
                Color.neutral800.opacity(0.5) :
                Color.neutral900
            )
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        isSelected ?
                        Color.neutral600 :
                        Color.neutral800,
                        lineWidth: DesignTokens.BorderWidth.standard
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct ColorSwatch: View {
    let hex: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
            .fill(Color(hex: hex))
            .frame(width: 24, height: 24)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                    .stroke(Color.neutral700, lineWidth: DesignTokens.BorderWidth.hairline)
            )
    }
}

// MARK: - System Info Row

struct SystemInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(.monoSM)
                .foregroundStyle(Color.App.textTertiary)
            
            Spacer()
            
            Text(value)
                .font(.monoSM)
                .foregroundStyle(Color.App.textSecondary)
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.sm)
    }
}

// MARK: - Button Style

struct PrimaryButtonStyle: ButtonStyle {
    let theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.monoSM)
            .foregroundStyle(Color(hex: theme.colors.primaryDim))
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                Color(hex: theme.colors.primary)
                    .opacity(configuration.isPressed ? 0.3 : 0.2)
            )
            .cornerRadius(DesignTokens.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                        lineWidth: DesignTokens.BorderWidth.standard
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

#Preview {
    @Previewable @State var state = TerminalState()
    
    SettingsView(state: $state, onDismiss: {})
}
