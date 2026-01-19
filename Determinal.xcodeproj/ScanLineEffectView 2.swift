//
//  ScanLineEffectView.swift
//  Determinal
//
//  CRT-style scan line effect overlay
//

import SwiftUI

struct ScanLineEffectView: View {
    let theme: Theme
    
    var body: some View {
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
            .frame(height: 100)
            .offset(y: scanLineOffset)
            .animation(
                .linear(duration: DesignTokens.Animation.scanLine)
                .repeatForever(autoreverses: false),
                value: scanLineOffset
            )
            .allowsHitTesting(false)
            .onAppear {
                scanLineOffset = UIScreen.main.bounds.height
            }
    }
    
    @State private var scanLineOffset: CGFloat = -100
}

/// Alternative repeating pattern scan line (more subtle)
struct RepeatingScanlinesView: View {
    let theme: Theme
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: Color(hex: theme.colors.primary).opacity(0.015), location: 0.5),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Rectangle()
                    .fill(.clear)
                    .background(
                        GeometryReader { geometry in
                            VStack(spacing: 4) {
                                ForEach(0..<Int(geometry.size.height / 8), id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color(hex: theme.colors.primary).opacity(0.015))
                                        .frame(height: 2)
                                    Spacer()
                                        .frame(height: 2)
                                }
                            }
                        }
                    )
            )
            .allowsHitTesting(false)
    }
}

#Preview("Animated Scan Line") {
    ZStack {
        Color.black
        ScanLineEffectView(theme: defaultTheme)
    }
}

#Preview("Repeating Scan Lines") {
    ZStack {
        Color.black
        RepeatingScanlinesView(theme: defaultTheme)
    }
}
