import SwiftUI

struct MainTabView: View {
    // One shared store keeps every tab synchronized.
    @State private var store = FinanceStore()

    var body: some View {
        TabView {
            DashboardView(store: store)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            TransactionsView(store: store)
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }

            AddTransactionView(store: store)
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }

            StatisticsView(store: store)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
