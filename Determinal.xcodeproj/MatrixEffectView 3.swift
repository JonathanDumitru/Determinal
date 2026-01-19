//
//  MatrixEffectView.swift
//  Determinal
//
//  Animated matrix rain background effect
//

import SwiftUI

struct MatrixEffectView: View {
    let theme: TerminalTheme
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                // Create matrix column effect
                let columns = Int(size.width / 20)
                let rows = Int(size.height / 20)
                
                for col in 0..<columns {
                    let height = CGFloat.random(in: 50...200)
                    let yOffset = (animationOffset + CGFloat(col * 20)).truncatingRemainder(dividingBy: size.height + height)
                    
                    // Draw fading trail
                    for i in 0..<Int(height / 20) {
                        let y = yOffset - CGFloat(i * 20)
                        if y >= -20 && y < size.height {
                            let opacity = 1.0 - (Double(i) / Double(height / 20))
                            let char = getRandomChar()
                            
                            var resolved = context.resolve(
                                Text(char)
                                    .font(.Terminal.terminalSmall)
                                    .foregroundStyle(Color(hex: theme.colors.primary).opacity(opacity * 0.15))
                            )
                            
                            let x = CGFloat(col * 20) + 10
                            resolved.shading = .color(Color(hex: theme.colors.primary).opacity(opacity * 0.15))
                            
                            context.draw(resolved, at: CGPoint(x: x, y: y))
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                animationOffset = 1000
            }
        }
        .allowsHitTesting(false)
    }
    
    private func getRandomChar() -> String {
        let chars = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン"
        return String(chars.randomElement() ?? "0")
    }
}

#Preview {
    ZStack {
        Color.black
        MatrixEffectView(theme: .matrix)
    }
}
