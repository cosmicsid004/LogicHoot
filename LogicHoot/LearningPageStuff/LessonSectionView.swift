//
//  SwiftUIView.swift
//  Gates
//
//  Created by Siddharth on 28/01/26.
//

import SwiftUI

struct LessonSectionView: View {
    var title:  String
    var subtitle: String
    var lessons: [Lesson]
    var accentColor: Color
    
    @Binding var selectedLesson: Lesson?
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
//                    Circle()
//                        .fill(accentColor.gradient)
//                        .frame(width: 10, height: 10)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(subtitle)
                            .font(.footnote)
                            .foregroundStyle(.primary.opacity(0.68))
                    }
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(lessons) { lesson in
                            LearnCard(lesson: lesson, accentColor: accentColor)
                                .onTapGesture {
                                    selectedLesson = lesson
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    
}

//#Preview {
//    LessonView(title: <#T##String#>, subtitle: <#T##String#>, lessons: <#T##[Lesson]#>, accentColor: <#T##Color#>)
//}
