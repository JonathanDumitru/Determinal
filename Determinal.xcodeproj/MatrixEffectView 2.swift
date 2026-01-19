//
//  MatrixEffectView.swift
//  Determinal
//
//  Animated matrix-style background effect
//

import SwiftUI

struct MatrixEffectView: View {
    let theme: Theme
    @State private var columns: [MatrixColumn] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.95)
                
                ForEach(columns) { column in
                    MatrixColumnView(column: column, theme: theme)
                }
            }
            .onAppear {
                generateColumns(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                generateColumns(for: newSize)
            }
        }
        .ignoresSafeArea()
    }
    
    private func generateColumns(for size: CGSize) {
        let columnCount = Int(size.width / 20)
        columns = (0..<columnCount).map { index in
            MatrixColumn(
                id: UUID(),
                xOffset: CGFloat(index) * 20,
                characters: generateRandomCharacters(),
                speed: Double.random(in: 2...6),
                opacity: Double.random(in: 0.1...0.3)
            )
        }
    }
    
    private func generateRandomCharacters() -> [String] {
        let chars = "01アイウエオカキクケコサシスセソ"
        return (0..<20).map { _ in String(chars.randomElement() ?? "0") }
    }
}

struct MatrixColumn: Identifiable {
    let id: UUID
    let xOffset: CGFloat
    let characters: [String]
    let speed: Double
    let opacity: Double
}

struct MatrixColumnView: View {
    let column: MatrixColumn
    let theme: Theme
    @State private var yOffset: CGFloat = -400
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(column.characters.enumerated()), id: \.offset) { index, char in
                Text(char)
                    .font(.monoXS)
                    .foregroundStyle(
                        Color(hex: theme.colors.primary)
                            .opacity(column.opacity * (1.0 - Double(index) / Double(column.characters.count)))
                    )
            }
        }
        .offset(x: column.xOffset, y: yOffset)
        .onAppear {
            withAnimation(
                .linear(duration: column.speed)
                .repeatForever(autoreverses: false)
            ) {
                yOffset = 1000
            }
        }
    }
}

#Preview {
    MatrixEffectView(theme: defaultTheme)
}
