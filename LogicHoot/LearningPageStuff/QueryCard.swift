//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 01/02/26.
//

import SwiftUI
import Foundation
import FoundationModels

struct QueryCard: View {
    var query: String = ""
    var onDismiss: (() -> Void)? = nil
    
    @State private var generatedText: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
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
                    HStack {
                        Text(query)
                            .font(.title2)
                        
                        Spacer()
                        
                        Image(.owl)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(20)
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if !generatedText.isEmpty {
                            Text(generatedText)
                                .font(.body)
                        } else {
                            Text("Tap to generate response")
                                .foregroundStyle(.secondary)
                                .padding()
                        }
                    }
                    .padding(20)
                }
                .background(Color.clear)
                .padding()
                .frame(maxHeight: 320)
            }
        }
        .background(
                IntelligenceColorCard()
        )
        .overlay (
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    //                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)
        .frame(width: 450)
        .task(id: query) {
            await loadGeneratedText()
        }
    }
    
    func loadGeneratedText() async {
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            generatedText = try await generateText(prompt: query)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func generateText(prompt: String) async throws -> String {
        if #available(iOS 26.0, *) {
            let session = LanguageModelSession()
            
            let response = try await session.respond(
                to: "act as a wise owl professor of logic gates and electronics, add a very minimal amount of owl humor in answers, dont answer if question is not valid" + prompt + "explain me in very concise terms"
            )
            
            return response.content
        } else {
            throw NSError(
                domain: "QueryCard",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "FoundationModels requires iOS 18.2 or later"]
            )
        }
    }
}

struct IntelligenceColorCard: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.thinMaterial)
            
            // Outer glow
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.blue.opacity(0.6),
                            Color.purple.opacity(0.6),
                            Color.pink.opacity(0.6),
                            Color.blue.opacity(0.6)
                        ],
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    lineWidth: 2
                )
                .blur(radius: 4)
            
            // Inner sharp stroke
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.blue.opacity(0.8),
                            Color.purple.opacity(0.8),
                            Color.pink.opacity(0.8),
                            Color.blue.opacity(0.8)
                        ],
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    lineWidth: 1.5
                )
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

//#Preview {
//    QueryCard(query: "What is use of logic gates")
//}

#Preview {
//    IntelligenceColorCard()
    ZStack {
        Color.black
        QueryCard()
    }
}
