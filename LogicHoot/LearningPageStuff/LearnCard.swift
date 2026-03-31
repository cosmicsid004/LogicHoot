//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 22/01/26.
//

import SwiftUI

struct LearnCard: View {
    let lesson: Lesson
    let accentColor: Color
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                if (lesson.isSFSymbol) {
                    Image(systemName: lesson.symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                } else {
                    Image(lesson.symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42)
                }
            }
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(lesson.title)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    Text(lesson.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.primary.opacity(0.8))
                        .lineLimit(1)
                                        
                }
                Spacer()
            }
        }
        .padding(20)
        .frame(width: 280, height: 210)
        .background(
            LinearGradient(colors: [accentColor, accentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
        .scaleEffect(isPressed ? 0.9: 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
    }
}


#Preview {
    HStack {
        LearnCard(lesson: DataModel.basicLessons[0], accentColor: .blue)
        LearnCard(lesson: DataModel.intermediateLessons[0], accentColor: .orange)
        LearnCard(lesson: DataModel.advanceLessons[0], accentColor: .purple)
    }
    .padding()
}
