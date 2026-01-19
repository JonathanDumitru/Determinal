import SwiftUI

/// Scan line CRT effect overlay
struct ScanLineEffectView: View {
    let themeColor: Color
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: themeColor.opacity(0.02), location: 0.5),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 200)
                .offset(y: offset)
                .onAppear {
                    withAnimation(
                        .linear(duration: 8)
                        .repeatForever(autoreverses: false)
                    ) {
                        offset = geometry.size.height + 200
                    }
                }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ScanLineEffectView(themeColor: .green)
        .background(Color.black)
}
