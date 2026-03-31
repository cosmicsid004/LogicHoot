//
//  CircuitType.swift
//  Gates
//
//  Created by Siddharth on 17/02/26.
//

import Foundation

// Output structure for circuits with multiple outputs
struct CircuitOutput {
    var primary: Bool      // Sum/Difference/Q
    var secondary: Bool    // Carry/Borrow/Q'
}

enum CircuitType: CaseIterable {
    case halfAdder
    case fullAdder
    case halfSubtractor
    case fullSubtractor
    case srLatch
    case dLatch
    case dFlipFlop
    case register
    
    var name: String {
        switch self {
        case .halfAdder: return "Half Adder"
        case .fullAdder: return "Full Adder"
        case .halfSubtractor: return "Half Subtractor"
        case .fullSubtractor: return "Full Subtractor"
        case .srLatch: return "SR Latch"
        case .dLatch: return "D Latch"
        case .dFlipFlop: return "D Flip-Flop"
        case .register: return "Register"
        }
    }
    
    var symbol: String {
        switch self {
        case .halfAdder: return "½+"
        case .fullAdder: return "+"
        case .halfSubtractor: return "½−"
        case .fullSubtractor: return "−"
        case .srLatch: return "SR"
        case .dLatch: return "DL"
        case .dFlipFlop: return "D"
        case .register: return "REG"
        }
    }
    
    var primaryOutputLabel: String {
        switch self {
        case .halfAdder, .fullAdder:
            return "S"  // Sum
        case .halfSubtractor, .fullSubtractor:
            return "D"  // Difference
        case .srLatch, .dLatch, .dFlipFlop, .register:
            return "Q"
        }
    }
    
    var secondaryOutputLabel: String {
        switch self {
        case .halfAdder, .fullAdder:
            return "C"  // Carry
        case .halfSubtractor, .fullSubtractor:
            return "B"  // Borrow
        case .srLatch, .dLatch, .dFlipFlop, .register:
            return "Q̄"
        }
    }
    
    var inputCount: Int {
        switch self {
        case .halfAdder, .halfSubtractor, .srLatch, .dLatch, .dFlipFlop:
            return 2
        case .fullAdder, .fullSubtractor:
            return 3
        case .register:
            return 2
        }
    }
    
    var inputLabels: [String] {
        switch self {
        case .halfAdder, .fullAdder:
            return ["A", "B", "Cin"]
        case .halfSubtractor, .fullSubtractor:
            return ["A", "B", "Bin"]
        case .srLatch:
            return ["S", "R"]
        case .dLatch:
            return ["D", "E"]
        case .dFlipFlop:
            return ["D", "CLK"]
        case .register:
            return ["D", "CLK"]
        }
    }
    
    func compute(_ a: Bool, _ b: Bool) -> CircuitOutput {
        switch self {
        case .halfAdder:
            //Sum =A XOR B, Carry= A AND B
            return CircuitOutput(primary: a != b, secondary: a && b)
            
        case .halfSubtractor:
            // Difference = A XOR B, Borrow = NOT A AND B
            return CircuitOutput(primary: a != b, secondary: !a && b)
            
        case .srLatch:
            // S=1,R=0 -> Q=1; S=0,R=1-> Q=0; S=0,R=0->hold(assume Q=0); S = 1,R=1 -> invalid (assume Q=0)
            let q: Bool
            if a && !b {        // Set
                q = true
            } else if !a && b { // Reset
                q = false
            } else {            // Hold /Invalid
                q = false
            }
            return CircuitOutput(primary: q, secondary: !q)
            
        case .dLatch:
            // When Enable = 1, Q follows D;When Enable=0, Q holds (assume 0)
            let q = b ? a : false
            return CircuitOutput(primary: q, secondary: !q)
            
        case .dFlipFlop:
            // Simplified: Q = D when clock is high
            let q = b ? a : false
            return CircuitOutput(primary: q, secondary: !q)
            
        case .register:
            let q = b ? a : false
            return CircuitOutput(primary: q, secondary: !q)
            
        default:
            return compute(a, b, false)
        }
    }
    
    //Compute output for 3-input circuits
    func compute(_ a: Bool, _ b: Bool, _ c: Bool) -> CircuitOutput {
        switch self {
        case .fullAdder:
            //Sum= A XOR B XOR Cin
            // Cout =(A AND B) OR (Cin AND (A XOR B))
            let xorAB = a != b
            let sum = xorAB != c
            let carry = (a && b) || (c && xorAB)
            return CircuitOutput(primary: sum, secondary: carry)
            
        case .fullSubtractor:
            // Difference= A XOR B XOR Bin
            // Bout=(NOT A AND B) OR (Bin AND NOT(A XOR B))
            let xorAB = a != b
            let diff = xorAB != c
            let borrow = (!a && b) || (c && !xorAB)
            return CircuitOutput(primary: diff, secondary: borrow)
            
        default:
            return compute(a, b)
        }
    }
}
