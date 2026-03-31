import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LearnPage()
                .tabItem {
                    Label("Learn", systemImage: "book")
                }
            
            PlayGroundCanvas()
                .tabItem {
                    Label("Playground", systemImage: "gamecontroller")
                }
        }
    }
}
