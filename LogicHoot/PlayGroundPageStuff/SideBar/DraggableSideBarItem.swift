//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI

struct DraggableSideBarItem: View {
    let element: SidebarElement
    @EnvironmentObject var viewModel: CanvasViewModel
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            // Item preview
            sidebarItemView
                .opacity(isDragging ? 0.5 : 1.0)
            
            // Dragging preview
            if isDragging {
                sidebarItemView
                    .offset(dragOffset)
                    .opacity(0.8)
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    isDragging = true
                    dragOffset = value.translation
                }
                .onEnded { value in
                    // Add component at drop location
                    let dropLocation = CGPoint(
                        x: value.location.x,
                        y: value.location.y
                    )
                    viewModel.addComponent(element, at: dropLocation)
                    
                    // Reset state
                    isDragging = false
                    dragOffset = .zero
                }
        )
    }
    
    private var sidebarItemView: some View {
        HStack {
            if element.label == "Switch" || element.label == "Bulb" {
                Image(systemName: element.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            } else {
                Image(element.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            Text(element.label)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}


//#Preview {
//    DraggableSideBarItem(element: <#SidebarElement#>)
//}
