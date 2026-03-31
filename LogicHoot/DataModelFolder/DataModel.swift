//
//  LessonData.swift
//  Gates
//
//  Created by Siddharth on 08/01/26.
//

import Foundation

class DataModel {
    static let basicLessons: [Lesson] = [
        Lesson(
            title: "Digital Logic",
            subtitle: "Understanding how machines think",
            level: .basic,
            symbol: "brain",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Digital electronics deals with systems that work using two fixed states ON and OFF. Unlike analog systems that vary continuously, digital systems use clear values, making them reliable, fast, and ideal for computers."
                )
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Analog VS Digital",
            subtitle: "Continuous signals vs discrete values",
            level: .basic,
            symbol: "waveform.path.ecg.text",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Analog signals change smoothly over time, like sound or temperature. Digital signals use fixed steps, usually 0 and 1, which makes them easier to store, process, and protect from noise."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Bits and Binary",
            subtitle: "The smallest unit of digital information",
            level: .basic,
            symbol: "01.circle",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "A bit is the smallest piece of data and can be either 0 or 1. By combining bits, computers represent numbers, letters, images, and everything else in binary form."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Logic Level",
            subtitle: "How voltage represents data",
            level: .basic,
            symbol: "stairs",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "In digital circuits, voltage levels represent data. A HIGH voltage means logic 1, and a LOW voltage means logic 0. This clear separation helps circuits avoid confusion."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Boolean Logic",
            subtitle: "Thinking in true and false",
            level: .basic,
            symbol: "01.circle.ar",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Boolean logic is a way of making decisions using true and false values. Computers use this logic to evaluate conditions and choose actions, just like decision-making in daily life."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Truth Table",
            subtitle: "A clear map of inputs and outputs",
            level: .basic,
            symbol: "tablecells",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "A truth table lists all possible input combinations and shows the corresponding output. It helps us understand how a logic operation behaves in every situation."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Logic Operations",
            subtitle: "Simple rules that control decisions",
            level: .basic,
            symbol: "scroll",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Basic logic operations define how inputs are combined. AND requires all conditions to be true, OR needs any one to be true, and NOT reverses the input result."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Why Logic Gates",
            subtitle: "Turning logic into hardware",
            level: .basic,
            symbol: "person.fill.questionmark",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Logic gates are physical circuits that implement Boolean logic. They allow computers to perform decisions using electrical signals instead of software instructions alone."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Real Examples",
            subtitle: "Logic you use every day",
            level: .basic,
            symbol: "iphone.gen1",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "Digital logic appears in everyday systems like phone locks, alarms, and traffic signals. These systems make decisions by checking conditions and producing outcomes automatically."),
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Ideas to Machine",
            subtitle: "From ideas to real machines",
            level: .basic,
            symbol: "lightbulb.max",
            sections: [
                LessonSection(
                    title: "What?",
                    body: "All complex digital systems are built from simple logic concepts. Understanding the basics makes it easier to learn logic gates, adders, flip-flops, and full computer architectures later."),
            ], isSFSymbol: true
        )
    ]
    
    static let intermediateLessons: [Lesson] = [
        Lesson(
            title: "Logic Gates",
            subtitle: "Hardware blocks that make decisions",
            level: .intermediate,
            symbol: "pedestrian.gate.closed",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "Logic gates are electronic circuits that perform basic logical operations. They take one or more inputs and produce a single output based on predefined logic rules.")
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "AND Gate",
            subtitle: "Output is true only when all inputs are true",
            level: .intermediate,
            symbol: "and",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "An AND gate produces a HIGH output only if every input is HIGH. It is commonly used where multiple conditions must be satisfied together."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "0"],
                        ["0", "1", "0"],
                        ["1", "0", "0"],
                        ["1", "1", "1"]
                    ]
                ),
            ], isSFSymbol: false, hasSimulation: true, gate: .and
        ),
        
        Lesson(
            title: "OR Gate",
            subtitle: "Output is true when any input is true",
            level: .intermediate,
            symbol: "or",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "An OR gate gives a HIGH output if at least one input is HIGH. It is useful in systems where meeting any condition is enough."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "0"],
                        ["0", "1", "1"],
                        ["1", "0", "1"],
                        ["1", "1", "1"]
                    ]),
            ], isSFSymbol: false, hasSimulation: true, gate: .or
        ),
        
        Lesson(
            title: "NOT Gate",
            subtitle: "Reversing the input logic",
            level: .intermediate,
            symbol: "not",
            
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "A NOT gate has a single input and produces the opposite output. It converts logic 1 to 0 and logic 0 to 1, acting as an inverter."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "Out"],
                        ["0", "1"],
                        ["1", "0"],
                    ]),
            ], isSFSymbol: false, hasSimulation: true, gate: .not
        ),
        
        Lesson(
            title: "Universal Gate",
            subtitle: "One gate to build them all",
            level: .intermediate,
            symbol: "globe",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "Universal gates are logic gates that can be used to construct any other gate. NAND and NOR are called universal because all digital circuits can be built using only one of them.")
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "NAND Gate",
            subtitle: "The inverted AND gate",
            level: .intermediate,
            symbol: "nand",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "A NAND gate produces a LOW output only when all inputs are HIGH. Because of its flexibility, it is widely used in digital circuit design."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "1"],
                        ["0", "1", "1"],
                        ["1", "0", "1"],
                        ["1", "1", "0"]
                    ]
                    ),
            ], isSFSymbol: false, hasSimulation: true, gate: .nand
        ),
        
        Lesson(
            title: "NOR Gate",
            subtitle: "The inverted OR gate",
            level: .intermediate,
            symbol: "nor",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "A NOR gate gives a HIGH output only when all inputs are LOW. Like NAND, it can be used alone to create any logic function."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "1"],
                        ["0", "1", "0"],
                        ["1", "0", "0"],
                        ["1", "1", "0"]
                    ]
                   ),
            ], isSFSymbol: false, hasSimulation: true, gate: .nor
        ),
        
        Lesson(
            title: "XOR Gate",
            subtitle: "True when inputs are different",
            level: .intermediate,
            symbol: "xor",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "An XOR gate outputs HIGH when the inputs are not the same. It is commonly used in comparison circuits and binary addition."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "0"],
                        ["0", "1", "1"],
                        ["1", "0", "1"],
                        ["1", "1", "0"]
                    ]
                    ),
            ], isSFSymbol: false, hasSimulation: true, gate: .xor
        ),
        
        Lesson(
            title: "XNOR Gate",
            subtitle: "True when inputs are the same",
            level: .intermediate,
            symbol: "xnor",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "An XNOR gate produces HIGH output when all inputs match. It is useful in equality checks and verification circuits."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Out"],
                        ["0", "0", "1"],
                        ["0", "1", "0"],
                        ["1", "0", "0"],
                        ["1", "1", "1"]
                    ]
                  ),
            ], isSFSymbol: false, hasSimulation: true, gate: .xnor
        ),
        
        Lesson(
            title: "Propagation Delay",
            subtitle: "Why outputs are not instant",
            level: .intermediate,
            symbol: "timer",
            sections:[
                LessonSection(
                    title: "Definition",
                    body: "Propagation delay is the small time a gate takes to change its output after an input changes. This delay becomes important in fast digital circuits.")
            ], isSFSymbol: true
        ),
    ]
    
    static let advanceLessons: [Lesson] = [
        Lesson(
            title: "Combinational Circuits",
            subtitle: "Output depends only on inputs",
            level: .advance,
            symbol: "circles.hexagonpath",
            sections: [LessonSection(
                title: "Definition",
                body: "Combinational circuits produce outputs based solely on current input values. They do not store data and are used in operations like addition and selection.")
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Sequential Circuits",
            subtitle: "Circuits that remember state",
            level: .advance,
            symbol: "point.topleft.down.to.point.bottomright.filled.curvepath",
            sections: [LessonSection(
                title: "Definition",
                body: "Sequential circuits store information and produce outputs based on current inputs and past states. Memory elements are essential to their operation.")
            ], isSFSymbol: true
        ),
        
        Lesson(
            title: "Half Adder",
            subtitle: "Adding two binary bits",
            level: .advance,
            symbol: "circle.lefthalf.striped.horizontal",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "A half adder is a combinational circuit that adds two single binary inputs. It produces a sum and a carry output, forming the basis of binary addition."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Sum", "C"],
                        ["0", "0", "0", "0"],
                        ["0", "1", "1", "0"],
                        ["1", "0", "1", "0"],
                        ["1", "1", "0", "1"]
                    ]
                   )
            ], isSFSymbol: true, hasSimulation: true, circuit: .halfAdder
        ),
        
        Lesson(
            title: "Full Adder",
            subtitle: "Adding bits with carry support",
            level: .advance,
            symbol: "moonphase.full.moon",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "A full adder adds three binary inputs, including a carry from a previous stage. It allows multiple adders to be connected for larger binary additions."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Cin", "Sum", "Cout"],
                        ["0", "0", "0", "0", "0"],
                        ["0", "0", "1", "1", "0"],
                        ["0", "1", "0", "1", "0"],
                        ["0", "1", "1", "0", "1"],
                        ["1", "0", "0", "1", "0"],
                        ["1", "0", "1", "0", "1"],
                        ["1", "1", "0", "0", "1"],
                        ["1", "1", "1", "1", "1"]
                    ]
)
            ], isSFSymbol: true, hasSimulation: true, circuit: .fullAdder
        ),
        
        Lesson(
            title: "Half Subtractor",
            subtitle: "Subtracting one bit from another",
            level: .advance,
            symbol: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "A half subtractor subtracts one binary input from another. It generates a difference and a borrow output for further subtraction stages."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Dif", "Bout"],
                        ["0", "0", "0", "0"],
                        ["0", "1", "1", "1"],
                        ["1", "0", "1", "0"],
                        ["1", "1", "0", "0"]
                    ]
)
            ], isSFSymbol: true, hasSimulation: true, circuit: .halfSubtractor
        ),
        
        Lesson(
            title: "Full Subtractor",
            subtitle: "Subtraction with borrow handling",
            level: .advance,
            symbol: "moonphase.full.moon",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "A full subtractor subtracts three binary inputs, including a borrow from a previous stage. It enables multi-bit binary subtraction."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["A", "B", "Bin", "Dif", "Bout"],
                        ["0", "0", "0", "0", "0"],
                        ["0", "0", "1", "1", "1"],
                        ["0", "1", "0", "1", "1"],
                        ["0", "1", "1", "0", "1"],
                        ["1", "0", "0", "1", "0"],
                        ["1", "0", "1", "0", "0"],
                        ["1", "1", "0", "0", "0"],
                        ["1", "1", "1", "1", "1"]
                    ]
)
            ], isSFSymbol: true, hasSimulation: true, circuit: .fullSubtractor
        ),
        
        Lesson(
            title: "SR Latch",
            subtitle: "Set-Reset memory element",
            level: .advance,
            symbol: "arrow.trianglehead.topright.capsulepath.clockwise",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "An SR Latch stores a single bit using Set and Reset inputs. S=1 sets Q to 1, R=1 resets Q to 0, and both 0 holds the previous state."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["S", "R", "Q", "Q̄"],
                        ["0", "0", "Hold", "Hold"],
                        ["0", "1", "0", "1"],
                        ["1", "0", "1", "0"],
                        ["1", "1", "Invalid", "Invalid"]
                    ]
)
            ], isSFSymbol: true, hasSimulation: true, circuit: .srLatch
        ),
        
        Lesson(
            title: "D Flip-Flop",
            subtitle: "Edge-triggered data storage",
            level: .advance,
            symbol: "opticaldisc",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "A D Flip-Flop captures the D input value on the clock edge. Q follows D when clock is high, providing synchronized data storage."),
                LessonSection(
                    title: "Truth Table",
                    table: [
                        ["D", "CLK", "Q", "Q̄"],
                        ["0", "1", "0", "1"],
                        ["1", "1", "1", "0"],
                        ["X", "0", "Hold", "Hold"]
                    ]
)
            ], isSFSymbol: true, hasSimulation: true, circuit: .dFlipFlop
        ),
        
        Lesson(
            title: "Register",
            subtitle: "Multi-bit data storage",
            level: .advance,
            symbol: "opticaldiscdrive",
            sections: [
                LessonSection(
                    title: "Definition",
                    body: "Registers are groups of flip-flops used to store binary data. They temporarily hold values during processing and data transfer."),
                LessonSection(
                    title: "Operation",
                    body: "When CLK is high, data D is stored. When CLK is low, the stored value is held regardless of input changes.")
            ], isSFSymbol: true, hasSimulation: true, circuit: .register
        ),
        
        Lesson(
            title: "Clock & Timing",
            subtitle: "Coordinating digital operations",
            level: .advance,
            symbol: "stopwatch",
            sections: [LessonSection(
                title: "Definition",
                body: "The clock signal controls when data is stored and updated in a circuit. Proper timing ensures that all parts of a system work together reliably.")
            ], isSFSymbol: true
        ),
    ]
}
