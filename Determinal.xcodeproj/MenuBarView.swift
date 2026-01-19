//
//  MenuBarView.swift
//  Determinal
//
//  Top menu bar with settings access
//

import SwiftUI

struct MenuBarView: View {
    @Binding var state: TerminalState
    @State private var showSettings = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Menu items could go here
            Spacer()
            
            // Settings button
            Button(action: { showSettings = true }) {
                Image(systemName: "gear")
                    .font(.system(size: DesignTokens.IconSize.md))
                    .foregroundStyle(Color.Terminal.textSecondary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .help("Settings (⌘,)")
            .padding(.trailing, DesignTokens.Spacing.md)
        }
        .frame(height: DesignTokens.Component.menuBarHeight)
        .background(Color.Terminal.surfacePrimary)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.Terminal.borderPrimary)
                .frame(height: DesignTokens.BorderWidth.regular)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(state: $state)
        }
    }
}

#Preview {
    @Previewable @State var state = TerminalState()
    
    MenuBarView(state: $state)
}
