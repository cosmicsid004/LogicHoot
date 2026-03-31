//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct SidebarDock: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    @State var isCollapsed: Bool = false
    
    let elements: [SidebarElement] = [
        .inputSwitch,
        .gate(.and),
        .gate(.or),
        .gate(.not),
        .gate(.nand),
        .gate(.nor),
        .gate(.xor),
        .gate(.xnor),
        .outputBulb
    ]
    
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack(spacing: 12) {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            isCollapsed.toggle()
                        }
                    } label: {
                        VStack {
                            Label {
                                Text("Components")
                                    .font(.headline)
                            } icon: {
                                Image(systemName: isCollapsed ? "chevron.compact.up": "chevron.compact.down")
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                if !isCollapsed {
                    ForEach(elements) { element in
                        DraggableSideBarItem(element: element)
//                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
            .padding()
            .background(
                LiquidGlassBackground(cornerRadius: 16)
            )
            .padding()
            .frame(width: 250)
            .animation(.spring(), value: isCollapsed)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct LiquidGlassBackground: View {
    var cornerRadius: CGFloat = 16

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
    }
}

#Preview {
    SidebarDock()
}
