import SwiftUI

struct DraggableComponentView: View {
    let component: PlacedComponent
    @ObservedObject var viewModel: CanvasViewModel
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDraggingComponent: Bool = false
    @State private var isSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {

            ZStack {
                componentView
                renderTerminals()
            }

            // Delete button attached to component
            if isSelected {
                Button {
                    viewModel.removeComponent(id: component.id)
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .background(
                            Circle().fill(Color.white)
                        )
                }
                .offset(x: 12, y: -12)
            }
        }
        .position(
            x: component.position.x + dragOffset.width,
            y: component.position.y + dragOffset.height
        )
        .gesture(
            DragGesture(coordinateSpace: .named("canvas"))
                .onChanged { value in
                    if !viewModel.isConnecting {
                        isDraggingComponent = true
                        isSelected = false            // hide button while dragging
                        dragOffset = value.translation
                        viewModel.setDragOffset(for: component.id, offset: value.translation)
                    }
                }
                .onEnded { value in
                    if isDraggingComponent {
                        let newPosition = CGPoint(
                            x: component.position.x + value.translation.width,
                            y: component.position.y + value.translation.height
                        )
                        viewModel.updatePosition(for: component.id, to: newPosition)
                        dragOffset = .zero
                        isDraggingComponent = false
                        viewModel.clearDragOffset(for: component.id)
                    }
                }
        )
        .onLongPressGesture(perform: {
            isSelected.toggle()
        })
        .onTapGesture {
            isSelected = false
        }
    }

    @ViewBuilder
    private func renderTerminals() -> some View {
        let terminals = viewModel.getComponentTerminals(component)
        
        ForEach(Array(terminals.enumerated()), id: \.offset) { _, terminalInfo in
            if let relativePos = getRelativePosition(for: terminalInfo.terminal) {
                InteractiveTerminal(
                    componentId: component.id,
                    terminal: terminalInfo.terminal,
                    position: terminalInfo.position,
                    isActive: getTerminalActiveState(terminalInfo.terminal),
                    viewModel: viewModel
                )
                .offset(x: relativePos.x, y: relativePos.y)
            }
        }
    }

    func getRelativePosition(for terminal: TerminalType) -> CGPoint? {
        switch component.element {
        case .gate(let type):
            let width: CGFloat = 100
            let height: CGFloat = 80
            
            switch terminal {
            case .inputA:
                return CGPoint(x: -width/2, y: -height * 0.2)
            case .inputB:
                if type == .not { return nil }
                return CGPoint(x: -width/2, y: height * 0.2)
            case .output:
                return CGPoint(x: width/2, y: 0)
            }
            
        case .inputSwitch:
            let size: CGFloat = 50
            return terminal == .output ? CGPoint(x: size/2, y: 0) : nil
            
        case .outputBulb:
            let size: CGFloat = 60
            return terminal == .inputA ? CGPoint(x: -size/2, y: 0) : nil
        }
    }

    func getTerminalActiveState(_ terminal: TerminalType) -> Bool {
        switch terminal {
        case .inputA:
            return component.inputA
        case .inputB:
            return component.inputB
        case .output:
            switch component.element {
            case .gate(let type):
                return type.compute(component.inputA, component.inputB)
            case .inputSwitch:
                return component.isOn
            case .outputBulb:
                return component.inputA
            }
        }
    }

    @ViewBuilder
    private var componentView: some View {
        switch component.element {
        case .gate(let type):
            LogicGateDesign(
                type: type,
                inputA: component.inputA,
                inputB: component.inputB
            )
            
        case .inputSwitch:
            InputSwitchDesign(
                isOn: Binding(
                    get: { component.isOn },
                    set: { _ in viewModel.toggleSwitch(id: component.id) }
                )
            )
            
        case .outputBulb:
            OutputBulbDesign(isOn: component.inputA)
        }
    }
}
