import SwiftUI

struct ContentView: View {
    var body: some View {
        // ContentView stays small and delegates the main navigation to MainTabView.
        MainTabView()
    }
}

#Preview {
    ContentView()
}
