//
//  CircuitDesign.swift
//  Gates
//
//  Created by Siddharth on 17/02/26.
//

import SwiftUI

struct CircuitDesign: View {
    let type: CircuitType
    var inputA: Bool = false
    var inputB: Bool = false
    var inputC: Bool = false  //Cin/Bin
    
    var width:CGFloat = 120
    var height: CGFloat = 100
    var terminalSize: CGFloat = 14
    
    var output: CircuitOutput {
        if type.inputCount == 3 {
            return type.compute(inputA, inputB, inputC)
        } else {
            return type.compute(inputA, inputB)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: width,height: height)
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
                    color: (output.primary || output.secondary) ? .purple.opacity(0.2) : .black.opacity(0.08),
                    radius: (output.primary || output.secondary) ? 15 : 8,
                    y: 4
                )
            
            VStack(spacing: 4) {
                Text(type.symbol)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(
                        (output.primary || output.secondary) ?
                        LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom)
                    )
                
                Text(type.name)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            // Input Terminals
            if type.inputCount == 2 {
                InputTerminalDesign(isActive: inputA, label: type.inputLabels[0])
                    .position(x: 0, y: height * 0.33)
                
                InputTerminalDesign(isActive: inputB, label: type.inputLabels[1])
                    .position(x: 0, y: height * 0.67)
            } else {
                InputTerminalDesign(isActive: inputA, label: type.inputLabels[0])
                    .position(x: 0, y: height * 0.25)
                
                InputTerminalDesign(isActive: inputB, label: type.inputLabels[1])
                    .position(x: 0, y: height * 0.5)
                
                InputTerminalDesign(isActive: inputC, label: type.inputLabels[2])
                    .position(x: 0, y: height * 0.75)
            }
            
            // Output Terminal
            OutputTerminalDesign(isActive: output.primary, label: type.primaryOutputLabel)
                .position(x: width, y: height * 0.33)
            
            //Carry/Borrow/Q'
            OutputTerminalDesign(isActive: output.secondary, label: type.secondaryOutputLabel)
                .position(x: width, y: height * 0.67)
        }
        .frame(width: width, height: height)
        .scaleEffect((output.primary || output.secondary) ? 1.03 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: output.primary)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: output.secondary)
    }
}

#Preview {
    VStack(spacing: 30) {
        CircuitDesign(type: .halfAdder, inputA: true, inputB: true)
        CircuitDesign(type: .fullAdder, inputA: true, inputB: false, inputC: true)
        CircuitDesign(type: .srLatch, inputA: true, inputB: false)
    }
    .padding()
}
