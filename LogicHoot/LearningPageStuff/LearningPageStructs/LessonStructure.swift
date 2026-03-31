//
//  File.swift
//  Gates
//
//  Created by Siddharth on 22/01/26.
//

import Foundation


struct LessonSection: Identifiable {
    let id = UUID()
    var title: String
    var body: String?
    var table: [[String]]?
}

enum LessonLevel {
    case basic
    case intermediate
    case advance
    
    var value: Int {
        switch self {
        case .basic: return 1
        case .intermediate: return 2
        case .advance: return 3
        }
    }
    
    var title: String {
        switch self {
        case .basic: return "Basic"
        case .intermediate: return "Intermediate"
        case .advance: return "Advance"
        }
    }
}

struct Lesson: Identifiable, Equatable {
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    var title: String
    var subtitle: String
    var level: LessonLevel
    var symbol: String
    var sections: [LessonSection]
    var isSFSymbol: Bool
    var hasSimulation: Bool?
    var gate: LogicGateType?
    var circuit: CircuitType?
}
