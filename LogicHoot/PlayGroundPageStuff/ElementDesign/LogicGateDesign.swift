//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct LogicGateDesign: View {
    
    let type: LogicGateType
    var inputA: Bool = false
    var inputB: Bool = false
    
    var width: CGFloat = 100
    var height: CGFloat = 80
    var terminalSize: CGFloat = 14
    
    var output: Bool {
        type.compute(inputA, inputB)
    }
    
    var body: some View {
        ZStack {
            // Main gate body
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: output ? .blue.opacity(0.2) : .black.opacity(0.08),
                    radius: output ? 15 : 8,
                    y: 4
                )
            
            // Gate label and symbol
            VStack(spacing: 6) {
                Text(type.symbol)
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(
                        output ?
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom)
                    )
                
                Text(type.name)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
            
            // Input Terminal A (top left)
            InputTerminalDesign(isActive: inputA, label: "")
                .position(x: 0, y: height * 0.3)
            
            // Input Terminal B (bottom left) - only for 2-input gates
            if type != .not {
                InputTerminalDesign(isActive: inputB, label: "")
                    .position(x: 0, y: height * 0.7)
            }
            
            // Output Terminal (right)
            OutputTerminalDesign(isActive: output, label: "Q")
                .position(x: width, y: height * 0.5)
        }
        .frame(width: width, height: height)
        .scaleEffect(output ? 1.03 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: output)
    }
}

#Preview {
    LogicGateDesign(type: .and)
}
