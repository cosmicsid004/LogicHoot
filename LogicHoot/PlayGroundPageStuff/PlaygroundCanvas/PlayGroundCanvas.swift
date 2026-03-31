//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 29/01/26.
//

import SwiftUI
import TipKit

struct tutorialTip: Tip, Identifiable {
    let id = UUID()
    var title: Text
    var message: Text?
}

struct PlayGroundCanvas: View {
    @StateObject private var viewModel = CanvasViewModel()
    @State var showTutorial: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                canvasBackground
                
                // Wires behind components
                ForEach(viewModel.connections) { connection in
                    WireView(connection: connection, viewModel: viewModel)
                }
                
                // Preview wire while connecting
                if viewModel.isConnecting,
                   let start = viewModel.connectionStart,
                   let dragPos = viewModel.currentDragPosition {
                    
                    let snapTarget = viewModel.findNearbyTerminal(at: dragPos, excluding: start.componentId)
                    let endPos = snapTarget?.position ?? dragPos
                    
                    PreviewWire(from: start.position, to: endPos)
                }
                
                // Components
                ForEach(viewModel.placedComponents) { component in
                    DraggableComponentView(
                        component: component,
                        viewModel: viewModel
                    )
                }
                
                // Sidebar
                VStack {
                    Spacer()
                    HStack {
                        SidebarDock()
                            .environmentObject(viewModel)
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        if #available(iOS 26.0, *) {
                            HStack(spacing: 12) {
                                Button(action: {
                                    showTutorial = true
                                }) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                .clipShape(Circle())
                                .buttonStyle(.glass)
                                .popoverTip(tutorialTip(title: Text("Tutorial"), message: Text("Tap for video tutorial")))
                                
                                Spacer()
                                
                                Button {
                                    viewModel.clearCanvas()
                                } label: {
                                    Text("Clear All")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                }
                                .background(.red.opacity(0.8))
                                .clipShape(Capsule())
                                .buttonStyle(.glass)
                            }
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                        }
                    }
                    
                    Spacer()
                }
            }
            .blur(radius: showTutorial ? 10 : 0)
            if showTutorial {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showTutorial = false
                    }
                    .transition(.opacity)
                VideoPlayerView(showTutorial: $showTutorial)
                    .frame(maxWidth: 480, maxHeight: 480)
                    .padding(.horizontal, 20)
                    .transition(
                        .asymmetric(insertion: .scale(scale: 0.9).combined(with: .opacity), removal: .scale(scale: 0.9).combined(with: .opacity))
                    )
            }
        }
        .coordinateSpace(name: "canvas")
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
                .onChanged { value in
                    if viewModel.isConnecting {
                        viewModel.updateConnectionDrag(to: value.location)
                    }
                }
                .onEnded { value in
                    if viewModel.isConnecting {
                        if let start = viewModel.connectionStart,
                           let target = viewModel.findNearbyTerminal(at: value.location, excluding: start.componentId) {
                            viewModel.completeConnection(to: target)
                        } else {
                            viewModel.cancelConnection()
                        }
                    }
                }
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showTutorial)
        .onAppear {
            // Store canvas offset for coordinate adjustments if needed
            viewModel.canvasOffset = .zero
        }
    }
    
    private var canvasBackground: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            Canvas { context, size in
                let spacing: CGFloat = 40
                
                for x in stride(from: 0, to: size.width, by: spacing) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    context.stroke(path, with: .color(.white.opacity(0.05)), lineWidth: 1)
                }
                
                for y in stride(from: 0, to: size.height, by: spacing) {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(path, with: .color(.white.opacity(0.05)), lineWidth: 1)
                }
            }
        }
    }
}
