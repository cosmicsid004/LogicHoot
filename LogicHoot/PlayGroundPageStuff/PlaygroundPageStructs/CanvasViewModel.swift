//
//  File.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import Foundation
internal import Combine
internal import CoreGraphics

class CanvasViewModel: ObservableObject {
    @Published var placedComponents: [PlacedComponent] = []
    @Published var connections: [WireConnection] = []
    
    // Wiring state
    @Published var isConnecting: Bool = false
    @Published var connectionStart: TerminalInfo?
    @Published var currentDragPosition: CGPoint?
    
    // Track component drag offsets for real-time wire updates
    @Published var componentDragOffsets: [UUID: CGSize] = [:]
    
    // Coordinate offset for tab view
    @Published var canvasOffset: CGPoint = .zero
    
    // Snap distanc
    let snapDistance: CGFloat = 40
    
    //add a new component at the specified position
    func addComponent(_ element: SidebarElement, at position: CGPoint) {
        let component = PlacedComponent(
            element: element,
            position: position
        )
        placedComponents.append(component)
    }
    
    // Update the position of an existing component
    func updatePosition(for id: UUID, to position: CGPoint) {
        if let index = placedComponents.firstIndex(where: { $0.id == id }) {
            placedComponents[index].position = position
            objectWillChange.send()
        }
    }
    
    //set drag offset for a component (for real-time wire updates)
    func setDragOffset(for id: UUID, offset: CGSize) {
        componentDragOffsets[id] = offset
    }
    
    //Clear drag offset for a component
    func clearDragOffset(for id: UUID) {
        componentDragOffsets.removeValue(forKey: id)
    }
    
    // Toggle switch state
    func toggleSwitch(id: UUID) {
        if let index = placedComponents.firstIndex(where: { $0.id == id }) {
            placedComponents[index].isOn.toggle()
            propagateSignals()
        }
    }
    
    // Remove a component from the canvas
    func removeComponent(id: UUID) {
        placedComponents.removeAll { $0.id == id }
        connections.removeAll { $0.fromComponentId == id || $0.toComponentId == id }
    }
    
    // MARK: - Wire Connection Logic
    
    //check if a terminal already has a connection
    func hasConnection(componentId: UUID, terminal: TerminalType) -> Bool {
        return connections.contains { conn in
            (conn.fromComponentId == componentId && conn.fromTerminal == terminal) ||
            (conn.toComponentId == componentId && conn.toTerminal == terminal)
        }
    }
    
    // Check if a connection can be made to a specific terminal
    func canConnectTo(componentId: UUID, terminal: TerminalType) -> Bool {
        // Check if terminal already has a connection
        return !hasConnection(componentId: componentId, terminal: terminal)
    }
    
    // Start creating a wire connection from a terminal
    func startConnection(from: TerminalInfo) {
        // Only allow starting from terminals that don't already have connections
        guard canConnectTo(componentId: from.componentId, terminal: from.terminal) else {
            return
        }
        
        isConnecting = true
        connectionStart = from
        currentDragPosition = from.position
    }
    
    // Update the current drag position while connecting
    func updateConnectionDrag(to position: CGPoint) {
        currentDragPosition = position
    }
    
    //try to snap to nearby terminal
    func findNearbyTerminal(at position: CGPoint, excluding excludeId: UUID) -> TerminalInfo? {
        for component in placedComponents {
            guard component.id != excludeId else { continue }
            
            let terminals = getComponentTerminals(component)
            
            for terminalInfo in terminals {
                // Skip terminals that already have connections
                guard canConnectTo(componentId: terminalInfo.componentId, terminal: terminalInfo.terminal) else {
                    continue
                }
                
                let distance = hypot(
                    terminalInfo.position.x - position.x,
                    terminalInfo.position.y - position.y
                )
                
                if distance < snapDistance {
                    return terminalInfo
                }
            }
        }
        return nil
    }
    
    //Get all terminals for a component
    func getComponentTerminals(_ component: PlacedComponent) -> [TerminalInfo] {
        var terminals: [TerminalInfo] = []
        
        switch component.element {
        case .gate(let type):
            if let pos = getTerminalPosition(componentId: component.id, terminal: .inputA) {
                terminals.append(TerminalInfo(componentId: component.id, terminal: .inputA, position: pos))
            }
            if type != .not, let pos = getTerminalPosition(componentId: component.id, terminal: .inputB) {
                terminals.append(TerminalInfo(componentId: component.id, terminal: .inputB, position: pos))
            }
            if let pos = getTerminalPosition(componentId: component.id, terminal: .output) {
                terminals.append(TerminalInfo(componentId: component.id, terminal: .output, position: pos))
            }
        case .inputSwitch:
            if let pos = getTerminalPosition(componentId: component.id, terminal: .output) {
                terminals.append(TerminalInfo(componentId: component.id, terminal: .output, position: pos))
            }
        case .outputBulb:
            if let pos = getTerminalPosition(componentId: component.id, terminal: .inputA) {
                terminals.append(TerminalInfo(componentId: component.id, terminal: .inputA, position: pos))
            }
        }
        
        return terminals
    }
    
    // Complete the wire connection to a terminal
    func completeConnection(to: TerminalInfo) {
        guard let start = connectionStart else { return }
        
        // Check if target terminal already has a connection
        guard canConnectTo(componentId: to.componentId, terminal: to.terminal) else {
            cancelConnection()
            return
        }
        
        let isValidConnection = (start.terminal == .output &&
                                 (to.terminal == .inputA || to.terminal == .inputB)) ||
        ((start.terminal == .inputA || start.terminal == .inputB) &&
         to.terminal == .output)
        
        if isValidConnection && start.componentId != to.componentId {
            let (fromId, fromTerminal, toId, toTerminal) = start.terminal == .output ?
            (start.componentId, start.terminal, to.componentId, to.terminal) :
            (to.componentId, to.terminal, start.componentId, start.terminal)
            
            let connectionExists = connections.contains { conn in
                conn.fromComponentId == fromId &&
                conn.fromTerminal == fromTerminal &&
                conn.toComponentId == toId &&
                conn.toTerminal == toTerminal
            }
            
            if !connectionExists {
                let connection = WireConnection(
                    fromComponentId: fromId,
                    fromTerminal: fromTerminal,
                    toComponentId: toId,
                    toTerminal: toTerminal
                )
                connections.append(connection)
                propagateSignals()
            }
        }
        
        cancelConnection()
    }
    
    // Cancel the current connection attempt
    func cancelConnection() {
        isConnecting = false
        connectionStart = nil
        currentDragPosition = nil
    }
    
    // Remove all the components from the canvas
    func clearCanvas() {
        connections.removeAll()
        placedComponents.removeAll()
    }
    
    // Remove a specific wire connection
    func removeConnection(id: UUID) {
        connections.removeAll { $0.id == id }
        propagateSignals()
    }
    
    // MARK: - Signal Propagation
    
    func propagateSignals() {
        // Reset all inputs first
        for i in placedComponents.indices {
            placedComponents[i].inputA = false
            placedComponents[i].inputB = false
        }
        
        // Propagate signals iteratively until stable
        let maxIterations = 100
        var iteration = 0
        var hasChanges = true
        
        while hasChanges && iteration < maxIterations {
            hasChanges = false
            iteration += 1
            
            for connection in connections {
                guard let fromIndex = placedComponents.firstIndex(where: { $0.id == connection.fromComponentId }),
                      let toIndex = placedComponents.firstIndex(where: { $0.id == connection.toComponentId }) else {
                    continue
                }
                
                let outputValue = getOutputValue(of: placedComponents[fromIndex])
                
                switch connection.toTerminal {
                case .inputA:
                    if placedComponents[toIndex].inputA != outputValue {
                        placedComponents[toIndex].inputA = outputValue
                        hasChanges = true
                    }
                case .inputB:
                    if placedComponents[toIndex].inputB != outputValue {
                        placedComponents[toIndex].inputB = outputValue
                        hasChanges = true
                    }
                case .output:
                    break
                }
            }
        }
        
        // Force UI update
        objectWillChange.send()
    }
    
    // Get the output value of a component
    private func getOutputValue(of component: PlacedComponent) -> Bool {
        switch component.element {
        case .gate(let type):
            return type.compute(component.inputA, component.inputB)
        case .inputSwitch:
            return component.isOn
        case .outputBulb:
            return component.inputA
        }
    }
    
    // Get terminal position for a component (includes drag offset for real-time updates)
    func getTerminalPosition(componentId: UUID, terminal: TerminalType) -> CGPoint? {
        guard let component = placedComponents.first(where: { $0.id == componentId }) else {
            return nil
        }
        
        // Apply drag offset if component is being dragged
        let dragOffset = componentDragOffsets[componentId] ?? .zero
        let basePos = CGPoint(
            x: component.position.x + dragOffset.width,
            y: component.position.y + dragOffset.height
        )
        
        switch component.element {
        case .gate(let type):
            let width: CGFloat = 100
            let height: CGFloat = 80
            
            switch terminal {
            case .inputA:
                return CGPoint(x: basePos.x - width/2, y: basePos.y - height * 0.2)
            case .inputB:
                if type == .not { return nil }
                return CGPoint(x: basePos.x - width/2, y: basePos.y + height * 0.2)
            case .output:
                return CGPoint(x: basePos.x + width/2, y: basePos.y)
            }
            
        case .inputSwitch:
            let size: CGFloat = 50
            return terminal == .output ? CGPoint(x: basePos.x + size/2, y: basePos.y) : nil
            
        case .outputBulb:
            let size: CGFloat = 60
            return terminal == .inputA ? CGPoint(x: basePos.x - size/2, y: basePos.y) : nil
        }
    }
}
