import Charts
import SwiftUI

struct StatisticsView: View {
    @Bindable var store: FinanceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Spending by Category")
                        .font(.title.bold())

                    if store.expensesByCategory.isEmpty {
                        ContentUnavailableView(
                            "No Expense Data",
                            systemImage: "chart.bar",
                            description: Text("Add expense transactions to see category totals.")
                        )
                        .frame(maxWidth: .infinity, minHeight: 280)
                    } else {
                        Chart(store.expensesByCategory, id: \.category) { item in
                            BarMark(
                                x: .value("Category", item.category.rawValue),
                                y: .value("Amount", item.total)
                            )
                            .foregroundStyle(by: .value("Category", item.category.rawValue))
                        }
                        .chartYAxisLabel("CAD")
                        .frame(height: 280)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category Totals")
                            .font(.headline)

                        ForEach(store.expensesByCategory, id: \.category) { item in
                            HStack {
                                Text(item.category.rawValue)
                                Spacer()
                                Text(item.total, format: .currency(code: "CAD"))
                                    .fontWeight(.semibold)
                            }
                            Divider()
                        }
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }
}

#Preview {
    StatisticsView(store: FinanceStore())
}
