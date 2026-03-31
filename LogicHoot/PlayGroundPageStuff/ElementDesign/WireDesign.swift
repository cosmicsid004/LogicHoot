//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct WireDesign: View {
    var from: CGPoint
    var to: CGPoint
    var isActive: Bool
    var thickness: CGFloat = 3
    
    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(
            isActive ?
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .init(x: from.x, y: from.y),
                endPoint: .init(x: to.x, y: to.y)
            ) :
            LinearGradient(
                colors: [.gray.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: thickness, lineCap: .round)
        )
        .shadow(
            color: isActive ? .indigo.opacity(0.5) : .clear,
            radius: isActive ? 6 : 0
        )
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

#Preview {
    WireDesign(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 400, y: 100), isActive: true)
}
