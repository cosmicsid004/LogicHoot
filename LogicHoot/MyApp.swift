import SwiftUI
import TipKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        do {
            try setupTips()
        } catch {
            print("Error initializing tips: \(error)")
        }
    }
    
    private func setupTips() throws {
        if #available(iOS 17.0, *) {
            try Tips.resetDatastore()
        }
        
        // Configure and load all tips in the app.
        if #available(iOS 17.0, *) {
            try Tips.configure([.displayFrequency(.immediate)])
        } else {
            // Fallback on earlier versions
        }
    }
}
