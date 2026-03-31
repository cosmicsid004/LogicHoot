import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var player = AVPlayer()
    @State private var currentVideoIndex = 0
    
    @Binding var showTutorial: Bool
    // Tutorial data
    let tutorials = [
        Tutorial(title: "Placing Items", description: "Drag items from the sidebar and drop them onto the canvas.", videoName: "itemDrag", accesbilityDiscription: "Drag items from the sidebar and drop them onto the canvas."),
        Tutorial(title: "Connecting Wires", description: "Tap the terminal and drag to connect.", videoName: "wireConnect", accesbilityDiscription: "Tap the terminal and drag to connect."),
        Tutorial(title: "Removing Items", description: "Long press the element to delete it.", videoName: "itemDelete", accesbilityDiscription: "Long press the element to delete it.")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with tutorial badge
            VStack(spacing: 16) {
                HStack {
                    // Tutorial badge
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 12, weight: .semibold))
                        Text("TUTORIAL")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.2)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Spacer()
                    
                    // Close button
                    Button {
                        showTutorial = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(tutorials[currentVideoIndex].title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .id(currentVideoIndex) // For animation
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                    Text(tutorials[currentVideoIndex].description)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .id("desc-\(currentVideoIndex)")
                        .transition(.opacity)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.easeInOut(duration: 0.3), value: currentVideoIndex)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)
            
            // Video Player
            ZStack {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(tutorials[currentVideoIndex].accesbilityDiscription)
//                    .accessibilityHint("Double tap to play or pause the video")
            }
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.05))
                    .padding(.horizontal, 20)
            )
            
            Spacer()
            
            // Progress bar
            HStack(spacing: 8) {
                ForEach(0..<tutorials.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentVideoIndex ? Color.orange : Color.secondary.opacity(0.2))
                        .frame(height: 4)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentVideoIndex)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            // Navigation Controls
            HStack(spacing: 16) {
                // Previous Button
                Button(action: previousVideo) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundStyle(currentVideoIndex == 0 ? .tertiary : .secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.1))
                    )
                }
                .buttonStyle(.plain)
                .disabled(currentVideoIndex == 0)
                
                Spacer()
                
                // Next/Finish Button
                Button(action: {
                    if currentVideoIndex == tutorials.count - 1 {
                        showTutorial = false
                    } else {
                        nextVideo()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(currentVideoIndex == tutorials.count - 1 ? "Get Started" : "Next")
                            .font(.system(size: 15, weight: .semibold))
                        Image(systemName: currentVideoIndex == tutorials.count - 1 ? "arrow.right" : "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.15), radius: 40, x: 0, y: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .onAppear {
            loadVideo()
        }
    }
    
    func loadVideo() {
        if let url = Bundle.main.url(forResource: tutorials[currentVideoIndex].videoName, withExtension: "mp4") {
            player = AVPlayer(url: url)
            player.isMuted = true
            
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                player.seek(to: .zero)
                player.play()
            }
            
            player.play()
        }
    }
    
    func nextVideo() {
        guard currentVideoIndex < tutorials.count - 1 else { return }
        currentVideoIndex += 1
        loadVideo()
    }
    
    func previousVideo() {
        guard currentVideoIndex > 0 else { return }
        currentVideoIndex -= 1
        loadVideo()
    }
}

struct Tutorial {
    let title: String
    let description: String
    let videoName: String
    let accesbilityDiscription: String
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoPlayerView(showTutorial: $showTutorial)
//            .frame(width: 500, height: 600)
//            .preferredColorScheme(.light)
//    }
//}
