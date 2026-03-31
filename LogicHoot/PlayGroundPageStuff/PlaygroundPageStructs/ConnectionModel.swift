//
//  File.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import Foundation

struct WireConnection: Identifiable {
    let id = UUID()
    let fromComponentId: UUID
    let fromTerminal: TerminalType
    let toComponentId: UUID
    let toTerminal: TerminalType
}

//Terminal Type
enum TerminalType: Equatable {
    case inputA
    case inputB
    case output
}

// Terminal Info
struct TerminalInfo {
    let componentId: UUID
    let terminal: TerminalType
    let position: CGPoint
}

// Placed Component Model
struct PlacedComponent: Identifiable {
    let id = UUID()
    let element: SidebarElement
    var position: CGPoint
    
    // For switches: track on/off state
    var isOn: Bool = false
    
    // For gates: track input connections
    var inputA: Bool = false
    var inputB: Bool = false
}
