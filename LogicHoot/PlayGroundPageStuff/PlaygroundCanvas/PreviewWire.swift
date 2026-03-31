//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct PreviewWire: View {
    let from: CGPoint
    let to: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: from)
            
            let controlPoint1 = CGPoint(
                x: from.x + (to.x - from.x) * 0.5,
                y: from.y
            )
            let controlPoint2 = CGPoint(
                x: from.x + (to.x - from.x) * 0.5,
                y: to.y
            )
            
            path.addCurve(to: to, control1: controlPoint1, control2: controlPoint2)
        }
        .stroke(
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10, 5])
        )
    }
}

#Preview {
    PreviewWire(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 100, y: 500))
}
