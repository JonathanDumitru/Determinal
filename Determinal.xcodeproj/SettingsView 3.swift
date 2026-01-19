//
//  SettingsView.swift
//  Determinal
//
//  Settings modal for model and theme selection
//

import SwiftUI

struct SettingsView: View {
    @Binding var state: TerminalState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "gear")
                    .font(.system(size: DesignTokens.IconSize.lg))
                    .foregroundStyle(Color(hex: state.theme.colors.primary))
                
                Text("SETTINGS")
                    .terminalTextStyle(.heading, color: .Terminal.textPrimary)
                    .textCase(.uppercase)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: DesignTokens.IconSize.md))
                        .foregroundStyle(Color.Terminal.textSecondary)
                }
                .buttonStyle(.plain)
                .help("Close")
            }
            .padding(DesignTokens.Spacing.lg)
            .background(Color.Terminal.surfacePrimary)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.Terminal.borderPrimary)
                    .frame(height: DesignTokens.BorderWidth.regular)
            }
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                    // Model Selection
                    ModelSelectionSection(state: $state)
                    
                    // Theme Selection
                    ThemeSelectionSection(state: $state)
                    
                    // System Info
                    SystemInfoSection(state: state)
                }
                .padding(DesignTokens.Spacing.xl)
            }
            
            // Footer
            HStack {
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle(theme: state.theme))
            }
            .padding(DesignTokens.Spacing.lg)
            .background(Color.Terminal.surfacePrimary)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.Terminal.borderPrimary)
                    .frame(height: DesignTokens.BorderWidth.regular)
            }
        }
        .frame(width: DesignTokens.Component.settingsModalWidth)
        .background(Color.Terminal.background)
    }
}

// MARK: - Model Selection Section
struct ModelSelectionSection: View {
    @Binding var state: TerminalState
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("AI MODEL")
                .terminalTextStyle(.label, color: Color(hex: state.theme.colors.primary))
                .textCase(.uppercase)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(AIModel.availableModels.filter(\.isDownloaded)) { model in
                    ModelSelectionCard(
                        model: model,
                        isSelected: state.currentModel?.id == model.id,
                        theme: state.theme
                    ) {
                        state.currentModel = model
                        state.systemResources.memoryUsed = model.size
                        state.history.append(
                            HistoryEntry(type: .system, content: "Model switched to \(model.name)")
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Model Selection Card
struct ModelSelectionCard: View {
    let model: AIModel
    let isSelected: Bool
    let theme: TerminalTheme
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                HStack {
                    Text(model.name)
                        .terminalTextStyle(
                            .body,
                            color: isSelected ? Color(hex: theme.colors.primary) : .Terminal.textPrimary
                        )
                        .fontWeight(isSelected ? .bold : .regular)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("ACTIVE")
                            .terminalTextStyle(.caption, color: Color(hex: theme.colors.primary))
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, DesignTokens.Spacing.xxs)
                            .background(
                                Color(hex: theme.colors.primary).opacity(DesignTokens.Opacity.light)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs)
                                    .stroke(
                                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                                        lineWidth: DesignTokens.BorderWidth.regular
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs))
                    }
                }
                
                HStack(spacing: DesignTokens.Spacing.lg) {
                    Text("Type: \(model.type.rawValue)")
                    Text("Size: \(model.size)MB")
                    Text("Format: \(model.quantization)")
                }
                .terminalTextStyle(.caption, color: .Terminal.textTertiary)
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? Color.Terminal.surfaceTertiary.opacity(0.5) : Color.Terminal.surfaceSecondary
            )
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        isHovered ? Color.Terminal.borderHover : Color.Terminal.borderPrimary,
                        lineWidth: DesignTokens.BorderWidth.regular
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Theme Selection Section
struct ThemeSelectionSection: View {
    @Binding var state: TerminalState
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("THEME")
                .terminalTextStyle(.label, color: Color(hex: state.theme.colors.primary))
                .textCase(.uppercase)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: DesignTokens.Spacing.md),
                    GridItem(.flexible(), spacing: DesignTokens.Spacing.md)
                ],
                spacing: DesignTokens.Spacing.md
            ) {
                ForEach(TerminalTheme.allThemes) { theme in
                    ThemeSelectionCard(
                        theme: theme,
                        isSelected: state.theme.id == theme.id,
                        currentTheme: state.theme
                    ) {
                        state.theme = theme
                        state.history.append(
                            HistoryEntry(type: .system, content: "Theme switched to \(theme.name)")
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Theme Selection Card
struct ThemeSelectionCard: View {
    let theme: TerminalTheme
    let isSelected: Bool
    let currentTheme: TerminalTheme
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Text(theme.name)
                        .terminalTextStyle(.bodySmall, color: .Terminal.textPrimary)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("ACTIVE")
                            .terminalTextStyle(.captionSmall, color: Color(hex: theme.colors.primary))
                            .padding(.horizontal, DesignTokens.Spacing.sm)
                            .padding(.vertical, DesignTokens.Spacing.xxs)
                            .background(
                                Color(hex: theme.colors.primary).opacity(DesignTokens.Opacity.light)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs)
                                    .stroke(
                                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                                        lineWidth: DesignTokens.BorderWidth.regular
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs))
                    }
                }
                
                // Color preview
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ColorSwatch(color: Color(hex: theme.colors.primary))
                    ColorSwatch(color: Color(hex: theme.colors.primaryDim))
                    ColorSwatch(color: Color(hex: theme.colors.primaryBright))
                }
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? Color.Terminal.surfaceTertiary.opacity(0.5) : Color.Terminal.surfaceSecondary
            )
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(
                        isHovered ? Color.Terminal.borderHover : Color.Terminal.borderPrimary,
                        lineWidth: DesignTokens.BorderWidth.regular
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Color Swatch
struct ColorSwatch: View {
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs)
            .fill(color)
            .frame(width: 24, height: 24)
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.xs)
                    .stroke(Color.Terminal.borderSecondary, lineWidth: DesignTokens.BorderWidth.regular)
            }
    }
}

// MARK: - System Info Section
struct SystemInfoSection: View {
    let state: TerminalState
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("SYSTEM INFORMATION")
                .terminalTextStyle(.label, color: Color(hex: state.theme.colors.primary))
                .textCase(.uppercase)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                SystemInfoRow(label: "Platform:", value: "macOS (simulated)")
                SystemInfoRow(label: "Architecture:", value: "arm64")
                SystemInfoRow(label: "Backend:", value: "llama.cpp")
                SystemInfoRow(label: "Version:", value: "1.0.0")
                SystemInfoRow(label: "Total Memory:", value: "\(state.systemResources.memoryTotal)MB")
            }
            .padding(DesignTokens.Spacing.md)
            .background(Color.Terminal.surfaceSecondary)
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md)
                    .stroke(Color.Terminal.borderPrimary, lineWidth: DesignTokens.BorderWidth.regular)
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.md))
        }
    }
}

// MARK: - System Info Row
struct SystemInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .terminalTextStyle(.bodySmall, color: .Terminal.textSecondary)
            
            Spacer()
            
            Text(value)
                .terminalTextStyle(.bodySmall, color: .Terminal.textPrimary)
        }
    }
}

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    let theme: TerminalTheme
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .terminalTextStyle(.body, color: Color(hex: theme.colors.primaryDim))
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.sm)
            .background(
                Color(hex: theme.colors.primary)
                    .opacity(isHovered ? 0.3 : DesignTokens.Opacity.light)
            )
            .overlay {
                RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm)
                    .stroke(
                        Color(hex: theme.colors.primaryDim).opacity(0.8),
                        lineWidth: DesignTokens.BorderWidth.regular
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.CornerRadius.sm))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

#Preview {
    @Previewable @State var state = TerminalState()
    
    SettingsView(state: $state)
}
