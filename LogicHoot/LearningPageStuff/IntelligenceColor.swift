//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 04/02/26.
//

import SwiftUI

struct IntelligenceColor: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Outer glow
            Capsule()
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.blue.opacity(0.6),
                            Color.purple.opacity(0.6),
                            Color.pink.opacity(0.6),
                            Color.blue.opacity(0.6)
                        ],
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    lineWidth: 2
                )
                .blur(radius: 4)
            
            // Inner sharp stroke
            Capsule()
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.blue.opacity(0.8),
                            Color.purple.opacity(0.8),
                            Color.pink.opacity(0.8),
                            Color.blue.opacity(0.8)
                        ],
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    lineWidth: 1.5
                )
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
#Preview {
    IntelligenceColor()
}
