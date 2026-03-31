//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct InputTerminalDesign: View {
    var isActive: Bool
    var label: String = ""
    var size: CGFloat = 14
    
    var body: some View {
        ZStack {
            // Glow when active
            if isActive {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.indigo.opacity(0.6), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 1.5
                        )
                    )
                    .frame(width: size * 3, height: size * 3)
                    .blur(radius: 4)
            }
            
            // Terminal body
            Circle()
                .fill(isActive ? .indigo : .gray.opacity(0.3))
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(0.5), lineWidth: 1)
                )
                .shadow(
                    color: isActive ? .indigo.opacity(0.8) : .clear,
                    radius: isActive ? 6 : 0
                )
            
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.white)
                    .offset(x: -size * 1.8, y: 0)
            }
        }
    }
}

#Preview {
    InputTerminalDesign(isActive: true)
}
