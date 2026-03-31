//
//  File.swift
//  Gates
//
//  Created by Siddharth on 28/01/26.
//

import Foundation

enum LogicGateType: CaseIterable {
    case and, or, nand, nor, xor, not, xnor
    
    var name: String {
        switch self {
        case .and: return "AND"
        case .or: return "OR"
        case .nand: return "NAND"
        case .xor: return "XOR"
        case .not: return "NOT"
        case .xnor: return "XNOR"
        case .nor: return "NOR"
        }
    }
    
    var symbol: String {
        switch self {
        case .and: return "∧"
        case .or: return "∨"
        case .nand: return "⊼"
        case .nor: return "⊽"
        case .xor: return "⊕"
        case .not: return "¬"
        case .xnor: return "⊙"
        }
    }
    
    func compute(_ a: Bool, _ b: Bool = false) -> Bool {
        switch self {
        case .and: return a && b
        case .or: return a || b
        case .nand: return !(a && b)
        case .nor: return !(a || b)
        case .xor: return a != b
        case .not: return !a
        case .xnor: return a == b
        }
    }
}
