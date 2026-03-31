//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct InteractiveTerminal: View {
    let componentId: UUID
    let terminal: TerminalType
    let position: CGPoint
    let isActive: Bool
    @ObservedObject var viewModel: CanvasViewModel
    
    @State private var isHighlighted = false
    
    var isOutput: Bool {
        terminal == .output
    }
    
    var hasConnection: Bool {
        viewModel.hasConnection(componentId: componentId, terminal: terminal)
    }
    
    var body: some View {
        ZStack {
            if shouldHighlight {
                Circle()
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 25, height: 25)
                    .scaleEffect(isHighlighted ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: isHighlighted)
                    .onAppear {
                        isHighlighted = true
                    }
                    .onDisappear {
                        isHighlighted = false
                    }
            }
            
            // Show red indicator if terminal already has connection
            if hasConnection && !viewModel.isConnecting {
                Circle()
                    .stroke(Color.red.opacity(0.3), lineWidth: 2)
                    .frame(width: 25, height: 25)
            }
            
            if isOutput {
                OutputTerminalDesign(isActive: isActive)
            } else {
                InputTerminalDesign(isActive: isActive, label: terminal == .inputA ? "A" : "B")
            }
            
            Circle()
                .fill(Color.clear)
                .frame(width: 35, height: 35)
                .contentShape(Circle())
        }
        .onTapGesture {
            handleTerminalTap()
        }
    }
    
    var shouldHighlight: Bool {
        guard viewModel.isConnecting else {
            return false
        }
        
        guard let start = viewModel.connectionStart,
              start.componentId != componentId else {
            return false
        }
        
        // Only highlight if terminal can accept a connection
        guard viewModel.canConnectTo(componentId: componentId, terminal: terminal) else {
            return false
        }
        
        return (start.terminal == .output && (terminal == .inputA || terminal == .inputB)) ||
        ((start.terminal == .inputA || start.terminal == .inputB) && terminal == .output)
    }
    
    func handleTerminalTap() {
        let terminalInfo = TerminalInfo(
            componentId: componentId,
            terminal: terminal,
            position: position
        )
        
        if viewModel.isConnecting {
            if let start = viewModel.connectionStart, start.componentId != componentId {
                viewModel.completeConnection(to: terminalInfo)
            }
        } else {
            // Only allow starting connection if terminal doesn't already have one
            if viewModel.canConnectTo(componentId: componentId, terminal: terminal) {
                viewModel.startConnection(from: terminalInfo)
            }
        }
    }
}

//
//#Preview {
//    InteractiveTerminal(componentId: <#UUID#>, terminal: <#TerminalType#>, position: <#CGPoint#>, isActive: <#Bool#>, viewModel: <#CanvasViewModel#>)
//}
