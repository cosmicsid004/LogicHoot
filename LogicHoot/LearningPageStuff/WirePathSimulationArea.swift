//
//  SwiftUIView.swift
//  Logic Hoot
//
//  Created by Siddharth on 18/02/26.
//

import SwiftUI

struct WirePath: View {
    let from: CGPoint
    let to: CGPoint
    let isActive: Bool
    
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
            
            path.addCurve(
                to: to,
                control1: controlPoint1,
                control2: controlPoint2
            )
        }
        .stroke(
            isActive ?
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            ) :
                LinearGradient(
                    colors: [.gray.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .shadow(
            color: isActive ? .indigo.opacity(0.5) : .clear,
            radius: isActive ? 8 : 0
        )
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}
