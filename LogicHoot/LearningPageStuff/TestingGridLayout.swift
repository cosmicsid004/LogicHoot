//
//  TestingGridLayout.swift
//  DataInGrids
//
//  Created by Siddharth on 18/02/26.
//
import SwiftUI

struct TestingGridLayout: View {
    
    let table: [[String]]
    
    var body: some View {
        Grid {
            ForEach(table.indices, id: \.self) { row in
                GridRow {
                    ForEach(table[row].indices, id: \.self) { column in
                        let value = table[row][column]
                        
                        Text(value)
                            .frame(width: 50, height: 40)
                            .background(backgroundColor(row: row, col: column, value: value))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding()
    }
    
    func backgroundColor(row: Int, col: Int, value: String) -> Color {
        if row == 0 {
            return .gray.opacity(0.4) // Header row
        }
        if (table[0][col] == "Cout") || (table[0][col] == "Out") || (table[0][col] == "Sum") || (table[0][col] == "C") || (table[0][col] == "Dif") || (table[0][col] == "Bout") || (table[0][col] == "Q") || (table[0][col] == "Q̄") {
            return .orange.opacity(0.4)
        }
        
        return .clear
    }
}

#Preview {
    TestingGridLayout(table: [
        ["A", "B", "Cin", "S", "Cout"],
        ["0", "0", "0", "0", "0"],
        ["0", "0", "1", "1", "0"],
        ["0", "1", "0", "1", "0"],
        ["0", "1", "1", "0", "1"],
        ["1", "0", "0", "1", "0"],
        ["1", "0", "1", "0", "1"],
        ["1", "1", "0", "0", "1"],
        ["1", "1", "1", "1", "1"]
    ])
}
