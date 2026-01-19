import SwiftUI

/// Toggle button for showing/hiding the chat panel
struct ChatToggleButton: View {
    let isVisible: Bool
    let theme: AppTheme
    let onToggle: () -> Void
    
    private var themeColor: Color {
        Color(hex: theme.primaryColor.primary)
    }
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: DesignTokens.Spacing.xs) {
                Circle()
                    .fill(themeColor)
                    .frame(width: 4, height: 4)
                
                Text("AI")
                    .font(.monoXS)
                    .foregroundStyle(themeColor)
                    .rotationEffect(.degrees(90))
                
                Circle()
                    .fill(themeColor)
                    .frame(width: 4, height: 4)
            }
            .padding(DesignTokens.Spacing.xs)
            .padding(.vertical, DesignTokens.Spacing.lg)
            .background(Color.panelBackground)
            .clipShape(
                .rect(
                    topLeadingRadius: DesignTokens.CornerRadius.md,
                    bottomLeadingRadius: DesignTokens.CornerRadius.md,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
            .overlay(alignment: .leading) {
                UnevenRoundedRectangle(
                    topLeadingRadius: DesignTokens.CornerRadius.md,
                    bottomLeadingRadius: DesignTokens.CornerRadius.md,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
                .strokeBorder(Color.borderDim, lineWidth: DesignTokens.BorderWidth.regular)
            }
        }
        .buttonStyle(.plain)
        .opacity(isVisible ? 0 : 1)
        .animation(.easeInOut(duration: DesignTokens.Duration.normal), value: isVisible)
    }
}

#Preview {
    HStack {
        Spacer()
        ChatToggleButton(
            isVisible: false,
            theme: .matrix,
            onToggle: {}
        )
    }
    .background(Color.appBackground)
}
