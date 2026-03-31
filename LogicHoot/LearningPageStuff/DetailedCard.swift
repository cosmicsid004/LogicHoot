//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 22/01/26.
//

import SwiftUI

struct DetailedCard: View {
    var lesson: Lesson
    var onDismiss: (() -> Void)? = nil
    
    @State private var switch1 = true
    @State private var switch2 = false
    @State private var switch3 = false  // For 3 input circuits
    @State private var terminalPositions: [String: CGPoint] = [:]
    
    private var levelColor: Color {
        switch lesson.level {
        case .basic: return .blue
        case .intermediate: return .orange
        case .advance: return .purple
        }
    }

    
    var body: some View {
                
        Grid {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .font(.caption2)
                    Text(lesson.level.title)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(levelColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(levelColor.opacity(0.2))
                .clipShape(Capsule())
                
                Spacer()
                
                if let onDismiss = onDismiss {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 28, height: 28)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            
            VStack(spacing: 4) {
                Text(lesson.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(lesson.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
            }
            .padding(.horizontal)
            
            GridRow {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(lesson.sections) { section in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(section.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                if let body = section.body {
                                    Text(body)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        .lineSpacing(4)
                                }
                                if let table = section.table {
                                    TestingGridLayout(table: table)
                                }
                            }
                        }
                    }
                    .frame(width: 400)
                }
                .padding()
                
                            
                    if lesson.gate != nil || lesson.circuit != nil {
                        VStack(spacing: 16) {
                            Text("Tap to interact")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            if lesson.gate != nil {
                                simulationArea(lesson: lesson)
                            }

                            if lesson.circuit != nil {
                                circuitSimulationArea(lesson: lesson)
                            }
                        }
                        .frame(width: 400)
                        .padding()
                    }
            }
            
            
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
        .frame(height: 550)
    }
    
    private func simulationArea(lesson: Lesson) -> some View {
        GeometryReader { geometry in
            ZStack {
                // Wire layer (behind components)
                // Wire from switch1 to gate input A
                if let switch1Pos = terminalPositions["switch1"],
                   let gateInputAPos = terminalPositions["gateInputA"] {
                    WirePath(
                        from: switch1Pos,
                        to: gateInputAPos,
                        isActive: switch1
                    )
                }
                
                // Wire from switch2 to gate input B (only for 2-input gates)
                if lesson.gate != .not,
                   let switch2Pos = terminalPositions["switch2"],
                   let gateInputBPos = terminalPositions["gateInputB"] {
                    WirePath(
                        from: switch2Pos,
                        to: gateInputBPos,
                        isActive: switch2
                    )
                }
                
                // Wire from gate output to bulb
                if let gateOutputPos = terminalPositions["gateOutput"],
                   let bulbInputPos = terminalPositions["bulbInput"] {
                    WirePath(
                        from: gateOutputPos,
                        to: bulbInputPos,
                        isActive: lesson.gate?.compute(switch1, switch2) ?? false
                    )
                }
                
                // Components layer
                HStack(spacing: 0) {
                    // Input switches
                    VStack(spacing: 60) {
                        if lesson.gate != .not {
                            InputSwitchDesign(isOn: $switch1)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "switch1": geo.frame(in: .named("simulationSpace"))
                                                    .rightCenter
                                            ]
                                        )
                                    }
                                )
                            
                            InputSwitchDesign(isOn: $switch2)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "switch2": geo.frame(in: .named("simulationSpace"))
                                                    .rightCenter
                                            ]
                                        )
                                    }
                                )
                        } else {
                            InputSwitchDesign(isOn: $switch1)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "switch1": geo.frame(in: .named("simulationSpace"))
                                                    .rightCenter
                                            ]
                                        )
                                    }
                                )
                        }
                    }
                    .padding(.trailing, 80)
                    
                    // Logic gate
                    LogicGateDesign(
                        type: lesson.gate ?? .and,
                        inputA: switch1,
                        inputB: switch2
                    )
                    .background (
                        GeometryReader { geo in
                            let frame = geo.frame(in: .named("simulationSpace"))
                            Color.clear.preference(
                                key: TerminalPreferenceKey.self,
                                value: [
                                    "gateInputA": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.33
                                    ),
                                    "gateInputB": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.67
                                    ),
                                    "gateOutput": frame.rightCenter
                                ]
                            )
                        }
                    )
                    .padding(.trailing, 80)
                    
                    // Output bulb
                    OutputBulbDesign(
                        isOn: lesson.gate?.compute(switch1, switch2) ?? false
                    )
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: TerminalPreferenceKey.self,
                                value: [
                                    "bulbInput": geo.frame(in: .named("simulationSpace"))
                                        .leftCenter
                                ]
                            )
                        }
                    )
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 12)
            }
            .coordinateSpace(name: "simulationSpace")
            .onPreferenceChange(TerminalPreferenceKey.self) { positions in
                terminalPositions = positions
            }
        }
        .frame(height: lesson.gate == .not ? 120 : 200)
    }
    
    private func circuitSimulationArea(lesson: Lesson) -> some View {
        GeometryReader { geometry in
            ZStack {
                let circuit = lesson.circuit!
                let output = circuit.inputCount == 3
                ? circuit.compute(switch1, switch2, switch3)
                : circuit.compute(switch1, switch2)
                
                // Wire layer (behind components)
                // Wire from switch1 to circuit input A
                if let switch1Pos = terminalPositions["circuitSwitch1"],
                   let circuitInputAPos = terminalPositions["circuitInputA"] {
                    WirePath(
                        from: switch1Pos,
                        to: circuitInputAPos,
                        isActive: switch1
                    )
                }
                
                // Wire from switch2 to circuit input B
                if let switch2Pos = terminalPositions["circuitSwitch2"],
                   let circuitInputBPos = terminalPositions["circuitInputB"] {
                    WirePath(
                        from: switch2Pos,
                        to: circuitInputBPos,
                        isActive: switch2
                    )
                }
                
                // Wire from switch3 to circuit input C (for 3-input circuits)
                if circuit.inputCount == 3,
                   let switch3Pos = terminalPositions["circuitSwitch3"],
                   let circuitInputCPos = terminalPositions["circuitInputC"] {
                    WirePath(
                        from: switch3Pos,
                        to: circuitInputCPos,
                        isActive: switch3
                    )
                }
                
                // Wire from circuit primary output to bulb1
                if let circuitOutputPrimaryPos = terminalPositions["circuitOutputPrimary"],
                   let bulb1InputPos = terminalPositions["bulb1Input"] {
                    WirePath(
                        from: circuitOutputPrimaryPos,
                        to: bulb1InputPos,
                        isActive: output.primary
                    )
                }
                
                // Wire from circuit secondary output to bulb2
                if let circuitOutputSecondaryPos = terminalPositions["circuitOutputSecondary"],
                   let bulb2InputPos = terminalPositions["bulb2Input"] {
                    WirePath(
                        from: circuitOutputSecondaryPos,
                        to: bulb2InputPos,
                        isActive: output.secondary
                    )
                }
                
                // Components layer
                HStack(spacing: 0) {
                    // Input switches
                    VStack(spacing: circuit.inputCount == 3 ? 30 : 50) {
                        InputSwitchDesign(isOn: $switch1, size: 45)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.preference(
                                        key: TerminalPreferenceKey.self,
                                        value: [
                                            "circuitSwitch1": geo.frame(in: .named("circuitSimulationSpace"))
                                                .rightCenter
                                        ]
                                    )
                                }
                            )
                        
                        InputSwitchDesign(isOn: $switch2, size: 45)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.preference(
                                        key: TerminalPreferenceKey.self,
                                        value: [
                                            "circuitSwitch2": geo.frame(in: .named("circuitSimulationSpace"))
                                                .rightCenter
                                        ]
                                    )
                                }
                            )
                        
                        if circuit.inputCount == 3 {
                            InputSwitchDesign(isOn: $switch3, size: 45)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "circuitSwitch3": geo.frame(in: .named("circuitSimulationSpace"))
                                                    .rightCenter
                                            ]
                                        )
                                    }
                                )
                        }
                    }
                    .padding(.trailing, 60)
                    
                    // Circuit component
                    CircuitDesign(
                        type: circuit,
                        inputA: switch1,
                        inputB: switch2,
                        inputC: switch3,
                        width: 100,
                        height: circuit.inputCount == 3 ? 90 : 80
                    )
                    .background(
                        GeometryReader { geo in
                            let frame = geo.frame(in: .named("circuitSimulationSpace"))
                            Color.clear.preference(
                                key: TerminalPreferenceKey.self,
                                value: circuit.inputCount == 3 ? [
                                    "circuitInputA": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.25
                                    ),
                                    "circuitInputB": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.5
                                    ),
                                    "circuitInputC": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.75
                                    ),
                                    "circuitOutputPrimary": CGPoint(
                                        x: frame.maxX,
                                        y: frame.minY + frame.height * 0.33
                                    ),
                                    "circuitOutputSecondary": CGPoint(
                                        x: frame.maxX,
                                        y: frame.minY + frame.height * 0.67
                                    )
                                ] : [
                                    "circuitInputA": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.33
                                    ),
                                    "circuitInputB": CGPoint(
                                        x: frame.minX,
                                        y: frame.minY + frame.height * 0.67
                                    ),
                                    "circuitOutputPrimary": CGPoint(
                                        x: frame.maxX,
                                        y: frame.minY + frame.height * 0.33
                                    ),
                                    "circuitOutputSecondary": CGPoint(
                                        x: frame.maxX,
                                        y: frame.minY + frame.height * 0.67
                                    )
                                ]
                            )
                        }
                    )
                    .padding(.trailing, 60)
                    
                    // Output bulbs (2 outputs)
                    VStack(spacing: 30) {
                        VStack(spacing: 4) {
                            OutputBulbDesign(isOn: output.primary, size: 50)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "bulb1Input": geo.frame(in: .named("circuitSimulationSpace"))
                                                    .leftCenter
                                            ]
                                        )
                                    }
                                )
                            Text(circuit.primaryOutputLabel)
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            OutputBulbDesign(isOn: output.secondary, size: 50)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: TerminalPreferenceKey.self,
                                            value: [
                                                "bulb2Input": geo.frame(in: .named("circuitSimulationSpace"))
                                                    .leftCenter
                                            ]
                                        )
                                    }
                                )
                            Text(circuit.secondaryOutputLabel)
                                .font(.caption2.bold())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .coordinateSpace(name: "circuitSimulationSpace")
            .onPreferenceChange(TerminalPreferenceKey.self) { positions in
                terminalPositions = positions
            }
        }
        .frame(height: lesson.circuit?.inputCount == 3 ? 220 : 200)
    }
}

// MARK: - Supporting Types
struct TerminalPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [String: CGPoint] = [:]
    
    static func reduce(value: inout [String: CGPoint], nextValue: () -> [String: CGPoint]) {
        value.merge(nextValue()) { _, new in new }
    }
}

extension CGRect {
    var leftCenter: CGPoint {
        CGPoint(x: minX, y: midY)
    }
    
    var rightCenter: CGPoint {
        CGPoint(x: maxX, y: midY)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        DetailedCard(lesson: DataModel.basicLessons[3], onDismiss: {})
            .frame(maxWidth: 380)
            .padding()
    }
}
