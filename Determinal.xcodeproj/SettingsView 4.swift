//
//  SettingsView.swift
//  Determinal
//
//  Settings panel for model selection and theme customization
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: TerminalViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "gearshape")
                    .font(.system(size: IconSize.md))
                    .foregroundStyle(viewModel.currentTheme.primary)
                
                Text("SETTINGS")
                    .font(.appHeader)
                    .foregroundStyle(Color.appTextPrimary)
                    .tracking(1.2)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: IconSize.md))
                        .foregroundStyle(Color.appTextTertiary)
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
            }
            .padding(Spacing.lg)
            .background(Color.appSurface)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.appBorder)
                    .frame(height: BorderWidth.standard)
            }
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.section) {
                    // Model Selection
                    modelSelectionSection
                    
                    // Theme Selection
                    themeSelectionSection
                    
                    // System Information
                    systemInfoSection
                }
                .padding(Spacing.lg)
            }
            
            // Footer
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.appButton)
                }
                .buttonStyle(PrimaryButtonStyle(theme: viewModel.currentTheme))
            }
            .padding(Spacing.lg)
            .background(Color.appSurface)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.appBorder)
                    .frame(height: BorderWidth.standard)
            }
        }
        .frame(width: 600, height: 700)
        .background(Color.appBackground)
    }
    
    // MARK: - Model Selection Section
    
    private var modelSelectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.base) {
            Text("AI MODEL")
                .labelText(color: viewModel.currentTheme.primary)
            
            VStack(spacing: Spacing.sm) {
                ForEach(viewModel.availableModels.filter { $0.isDownloaded }) { model in
                    ModelCard(
                        model: model,
                        isActive: viewModel.currentModel?.id == model.id,
                        theme: viewModel.currentTheme,
                        onSelect: {
                            viewModel.changeModel(model)
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Theme Selection Section
    
    private var themeSelectionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.base) {
            Text("THEME")
                .labelText(color: viewModel.currentTheme.primary)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: Spacing.md
            ) {
                ForEach(AppTheme.allThemes, id: \.id) { theme in
                    ThemeCard(
                        theme: theme,
                        isActive: viewModel.currentTheme.id == theme.id,
                        onSelect: {
                            viewModel.changeTheme(theme)
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - System Info Section
    
    private var systemInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.base) {
            Text("SYSTEM INFORMATION")
                .labelText(color: viewModel.currentTheme.primary)
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                InfoRow(label: "Platform:", value: "macOS")
                InfoRow(label: "Architecture:", value: "arm64")
                InfoRow(label: "Backend:", value: "llama.cpp")
                InfoRow(label: "Version:", value: "1.0.0")
                InfoRow(label: "Total Memory:", value: "\(viewModel.systemResources.memoryTotal)MB")
            }
            .padding(Spacing.base)
            .background(Color.appSurface)
            .cornerRadius(CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(Color.appBorder, lineWidth: BorderWidth.standard)
            )
        }
    }
}

// MARK: - Model Card

private struct ModelCard: View {
    let model: AIModel
    let isActive: Bool
    let theme: AppTheme
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text(model.name)
                        .font(.appSubheader)
                        .foregroundStyle(isActive ? theme.primary : Color.appTextPrimary)
                    
                    Spacer()
                    
                    if isActive {
                        Text("ACTIVE")
                            .font(.appLabelSmall)
                            .foregroundStyle(theme.primary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(theme.primary.opacity(0.15))
                            .cornerRadius(CornerRadius.sm)
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.sm)
                                    .stroke(theme.primaryDim.opacity(0.5), lineWidth: BorderWidth.standard)
                            )
                    }
                }
                
                HStack(spacing: Spacing.base) {
                    Text("Type: \(model.type.rawValue)")
                    Text("Size: \(model.size)MB")
                    Text("Format: \(model.quantization)")
                }
                .font(.appSmall)
                .foregroundStyle(Color.appTextTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.base)
            .background(isActive ? Color.appSurfaceElevated : Color.appSurface)
            .cornerRadius(CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(
                        isActive ? Color.appBorderHover :
                            (isHovered ? Color.appBorderHover : Color.appBorder),
                        lineWidth: BorderWidth.standard
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Theme Card

private struct ThemeCard: View {
    let theme: AppTheme
    let isActive: Bool
    let onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    Text(theme.name)
                        .font(.appButton)
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Spacer()
                    
                    if isActive {
                        Text("ACTIVE")
                            .font(.appLabelSmall)
                            .foregroundStyle(theme.primary)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical: Spacing.xxs)
                            .background(theme.primary.opacity(0.15))
                            .cornerRadius(CornerRadius.sm)
                    }
                }
                
                // Color preview
                HStack(spacing: Spacing.xs) {
                    Circle()
                        .fill(theme.primary)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .fill(theme.primaryDim)
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .fill(theme.primaryBright)
                        .frame(width: 20, height: 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.base)
            .background(isActive ? Color.appSurfaceElevated : Color.appSurface)
            .cornerRadius(CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(
                        isActive ? Color.appBorderHover :
                            (isHovered ? Color.appBorderHover : Color.appBorder),
                        lineWidth: BorderWidth.standard
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Info Row

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.appMonoSmall)
                .foregroundStyle(Color.appTextTertiary)
            
            Spacer()
            
            Text(value)
                .font(.appMonoSmall)
                .foregroundStyle(Color.appTextSecondary)
        }
    }
}

// MARK: - Primary Button Style

struct PrimaryButtonStyle: ButtonStyle {
    let theme: AppTheme
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Spacing.base)
            .padding(.vertical, Spacing.sm)
            .background(theme.primary.opacity(isHovered ? 0.3 : 0.2))
            .foregroundStyle(isHovered ? theme.primary : theme.primaryDim)
            .cornerRadius(CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(theme.primaryDim.opacity(0.5), lineWidth: BorderWidth.standard)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: TerminalViewModel())
}
