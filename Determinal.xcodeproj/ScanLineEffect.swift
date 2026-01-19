//
//  ScanLineEffect.swift
//  Determinal
//
//  CRT-style scan line overlay effect
//

import SwiftUI

struct ScanLineEffect: View {
    let theme: TerminalTheme
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            Color(hex: theme.colors.primary).opacity(0.02),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 4)
                .offset(y: offset)
                .onAppear {
                    withAnimation(
                        .linear(duration: DesignTokens.Animation.scan)
                        .repeatForever(autoreverses: false)
                    ) {
                        offset = geometry.size.height
                    }
                }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color.black
        ScanLineEffect(theme: .matrix)
    }
}
