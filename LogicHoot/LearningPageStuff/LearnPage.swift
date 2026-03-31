//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 28/01/26.
//

import SwiftUI

struct LearnPage: View {
    private var basicLesson = DataModel.basicLessons
    private var intermediateLesson = DataModel.intermediateLessons
    private var advanceLesson = DataModel.advanceLessons
    
    @State private var showQueryCard: Bool = false
    @State private var submittedQuery: String = ""
    @State private var doubt: String = ""
    
    @FocusState private var isFocused: Bool
    
    @State private var selectedLesson: Lesson?
    var body: some View {
        VStack {
            ZStack() {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        LessonSectionView(title: "Basic", subtitle: "Start from the fundamentals", lessons: basicLesson, accentColor: .blue, selectedLesson: $selectedLesson)
                        
                        LessonSectionView(title: "Intermediate", subtitle: "Build on you knowledge", lessons: intermediateLesson, accentColor: .orange, selectedLesson: $selectedLesson)
                        
                        LessonSectionView(title: "Advance", subtitle: "Start from the fundamentals", lessons: advanceLesson, accentColor: .purple, selectedLesson: $selectedLesson)
                        
                        Spacer(minLength: 40)
                    }
                }
                .blur(radius: selectedLesson != nil ? 10 : 0)
                
                if !isFocused {
                    if let lesson = selectedLesson {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                selectedLesson = nil
                            }
                            .transition(.opacity)
                        
                        DetailedCard(lesson: lesson, onDismiss: {selectedLesson = nil})
                            .frame(maxWidth: 380)
                            .padding(.horizontal, 20)
                            .transition(
                                .asymmetric(insertion: .scale(scale: 0.9).combined(with: .opacity), removal: .scale(scale: 0.9).combined(with: .opacity))
                            )
                            .zIndex(1)
                    }
                }
                
                if showQueryCard {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showQueryCard = false
                        }
                        .transition(.opacity)
                    
                    QueryCard(query: submittedQuery, onDismiss: {
                        showQueryCard = false
                    })
                    .frame(maxWidth: 380)
                    .padding(.horizontal, 20)
                    .zIndex(2)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedLesson)
            .overlay (alignment: .bottom) {
                HStack {
                    Image(.owl)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    TextField("Ask a question...", text: $doubt)
                        .padding()
                        .focused($isFocused)
                        .onSubmit {
                            isFocused = false
                            submitQuery()
                        }
                        .background(
                            ZStack {
                                Capsule()
                                    .fill(Color(.systemBackground))
                                
                                // Animated glowing edge effect
                                IntelligenceColor()
                            }
                        )
                    
                    if !doubt.isEmpty {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 50, height: 50)
                                .background(IntelligenceColor())
                            
                            Image(systemName: "arrow.up")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .onTapGesture {
                            submitQuery()
                        }
                    }
                }
                .padding()
                .background(.clear)
            }
            
        }
    }
    
    private func submitQuery() {
        guard !doubt.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        showQueryCard = true
        submittedQuery = doubt
        doubt = ""
    }
}

#Preview {
    LearnPage()
}
