import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .animation(.easeInOut, value: isLoggedIn)
    }
}

#Preview {
    ContentView()
}
