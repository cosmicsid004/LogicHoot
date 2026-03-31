//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct WireView: View {
    let connection: WireConnection
    @ObservedObject var viewModel: CanvasViewModel
    
    var fromPosition: CGPoint {
        viewModel.getTerminalPosition(
            componentId: connection.fromComponentId,
            terminal: connection.fromTerminal
        ) ?? .zero
    }
    
    var toPosition: CGPoint {
        viewModel.getTerminalPosition(
            componentId: connection.toComponentId,
            terminal: connection.toTerminal
        ) ?? .zero
    }
    
    var isActive: Bool {
        guard let fromComponent = viewModel.placedComponents.first(where: { $0.id == connection.fromComponentId }) else {
            return false
        }
        
        switch fromComponent.element {
        case .gate(let type):
            return type.compute(fromComponent.inputA, fromComponent.inputB)
        case .inputSwitch:
            return fromComponent.isOn
        case .outputBulb:
            return fromComponent.inputA
        }
    }
    
    var body: some View {
        Path { path in
            path.move(to: fromPosition)
            
            let controlPoint1 = CGPoint(
                x: fromPosition.x + (toPosition.x - fromPosition.x) * 0.5,
                y: fromPosition.y
            )
            let controlPoint2 = CGPoint(
                x: fromPosition.x + (toPosition.x - fromPosition.x) * 0.5,
                y: toPosition.y
            )
            
            path.addCurve(
                to: toPosition,
                control1: controlPoint1,
                control2: controlPoint2
            )
        }
        .stroke(
            isActive ?
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            ) :
                LinearGradient(
                    colors: [.gray.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .shadow(
            color: isActive ? .indigo.opacity(0.5) : .clear,
            radius: isActive ? 8 : 0
        )
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .contentShape(Path { path in
            path.move(to: fromPosition)
            let controlPoint1 = CGPoint(
                x: fromPosition.x + (toPosition.x - fromPosition.x) * 0.5,
                y: fromPosition.y
            )
            let controlPoint2 = CGPoint(
                x: fromPosition.x + (toPosition.x - fromPosition.x) * 0.5,
                y: toPosition.y
            )
            path.addCurve(to: toPosition, control1: controlPoint1, control2: controlPoint2)
        })
        .onTapGesture {
            viewModel.removeConnection(id: connection.id)
        }
    }
}



//#Preview {
//    WireView(connection: <#WireConnection#>, viewModel: <#CanvasViewModel#>)
//}
