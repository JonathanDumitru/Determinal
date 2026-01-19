import SwiftUI

/// Matrix-style falling characters background effect
struct MatrixEffectView: View {
    let theme: AppTheme
    
    @State private var columns: [MatrixColumn] = []
    private let numberOfColumns = 30
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(columns) { column in
                    MatrixColumnView(
                        column: column,
                        themeColor: Color(hex: theme.primaryColor.primary)
                    )
                }
            }
            .onAppear {
                setupColumns(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .background(Color.matrixBackground)
    }
    
    private func setupColumns(width: CGFloat, height: CGFloat) {
        let columnWidth = width / CGFloat(numberOfColumns)
        
        columns = (0..<numberOfColumns).map { index in
            MatrixColumn(
                id: index,
                x: CGFloat(index) * columnWidth,
                characters: generateRandomCharacters(),
                speed: Double.random(in: 20...40),
                startDelay: Double.random(in: 0...3)
            )
        }
    }
    
    private func generateRandomCharacters() -> [String] {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()".map { String($0) }
        return (0..<15).map { _ in chars.randomElement() ?? "0" }
    }
}

// MARK: - Matrix Column

struct MatrixColumn: Identifiable {
    let id: Int
    let x: CGFloat
    let characters: [String]
    let speed: Double
    let startDelay: Double
}

struct MatrixColumnView: View {
    let column: MatrixColumn
    let themeColor: Color
    
    @State private var offset: CGFloat = -500
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<column.characters.count, id: \.self) { index in
                Text(column.characters[index])
                    .font(.monoXS)
                    .foregroundStyle(themeColor.opacity(opacityForIndex(index)))
            }
        }
        .offset(x: column.x, y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(
                .linear(duration: column.speed)
                .repeatForever(autoreverses: false)
                .delay(column.startDelay)
            ) {
                offset = 1000
                opacity = 0.3
            }
        }
    }
    
    private func opacityForIndex(_ index: Int) -> Double {
        let position = Double(index) / Double(column.characters.count)
        return position // Fade from top to bottom
    }
}

#Preview {
    MatrixEffectView(theme: .matrix)
}
