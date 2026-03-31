//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct InputSwitchDesign: View {
    @Binding var isOn: Bool
    var size: CGFloat = 50
    
    var body: some View {
        ZStack {
            // Switch body
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .strokeBorder(.white.opacity(0.4), lineWidth: 1)
                )
            
            // Active indicator
            if isOn {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.indigo.opacity(0.8), .purple.opacity(0.6)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.4
                        )
                    )
                    .frame(width: size * 0.8)
                    .shadow(color: .indigo.opacity(0.6), radius: 10)
            }
            
            // Label
            Text(isOn ? "1" : "0")
                .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
                .foregroundStyle(isOn ? .white : .secondary)
            
            // Output terminal
            OutputTerminalDesign(isActive: isOn)
                .position(x: size, y: size * 0.5)
        }
        .frame(width: size, height: size)
        .contentShape(Circle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isOn.toggle()
            }
        }
    }
}

//#Preview {
//    InputSwitchDesign(isOn: true)
//}
