//
//  File.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import Foundation

enum SidebarElement: Identifiable, Equatable {
    case gate(LogicGateType)
    case inputSwitch
    case outputBulb
    
    var id: String {
        switch self {
        case .gate(let type): return "gate-\(type.symbol)"
        case .inputSwitch: return "switch"
        case .outputBulb: return "bulb"
        }
    }
    
    var icon: String {
        switch self {
        case .gate(.and): return "and"
        case .gate(.or): return "or"
        case .gate(.not): return "not"
        case .gate(.nor): return "nor"
        case .gate(.xnor): return "xnor"
        case .gate(.xor): return "xor"
        case .gate(.nand): return "nand"
        case .inputSwitch: return "switch.2"
        case .outputBulb: return "lightbulb"
        }
    }
    
    var label: String {
        switch self {
        case .gate(let type): return type.name.uppercased()
        case .inputSwitch: return "Switch"
        case .outputBulb: return "Bulb"
        }
    }
}
