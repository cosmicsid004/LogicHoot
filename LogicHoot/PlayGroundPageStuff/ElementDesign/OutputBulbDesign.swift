//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct OutputBulbDesign: View {
    var isOn: Bool
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            // glow
            if isOn {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow.opacity(0.5), .orange.opacity(0.2), .clear],
                            center: .center,
                            startRadius: size * 0.3,
                            endRadius: size * 1.2
                        )
                    )
                    .frame(width: size * 2, height: size * 2)
                    .blur(radius: 8)
            }
            
            // Bulb body
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(0.4), lineWidth: 1)
                )
            
            // Light fill
            if isOn {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.yellow, .orange],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.4
                        )
                    )
                    .frame(width: size * 0.8, height: size * 0.8)
            }
            
            // Bulb icon
            if #available(iOS 17.0, *) {
                Image(systemName: isOn ? "lightbulb.max.fill" : "lightbulb")
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(isOn ? .white : .secondary)
                    .symbolEffect(.bounce, value: isOn)
            } else {
                // Fallback on earlier versions
            }
            
            // Input terminal
            InputTerminalDesign(isActive: isOn)
                .offset(x: -size * 0.5, y: size * 0.01)
        }
        .frame(width: size, height: size)
    }}

#Preview {
    OutputBulbDesign(isOn: true)
}
