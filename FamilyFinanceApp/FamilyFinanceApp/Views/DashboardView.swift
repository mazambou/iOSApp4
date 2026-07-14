import SwiftUI

struct DashboardView: View {
    @Bindable var store: FinanceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Family Finance Canada")
                            .font(.largeTitle.bold())

                        Text("Track your monthly household budget in Canadian dollars.")
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Budget Used")
                                .font(.headline)
                            Spacer()
                            Text(store.budgetUsedRatio, format: .percent.precision(.fractionLength(0)))
                                .font(.headline)
                        }

                        ProgressView(value: store.budgetUsedRatio)
                            .tint(store.remainingBudget >= 0 ? .green : .red)

                        Text("Monthly budget: \(store.monthlyBudget, format: .currency(code: "CAD"))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        SummaryCard(title: "Income", value: store.monthlyIncome, color: .green, icon: "arrow.down.circle.fill")
                        SummaryCard(title: "Expenses", value: store.monthlyExpenses, color: .red, icon: "arrow.up.circle.fill")
                        SummaryCard(title: "Remaining", value: store.remainingBudget, color: store.remainingBudget >= 0 ? .blue : .red, icon: "wallet.pass.fill")
                        SummaryCard(title: "Transactions", value: Double(store.transactions.count), color: .purple, icon: "list.bullet", isCurrency: false)
                    }

                    Stepper(
                        "Monthly Budget: \(store.monthlyBudget, format: .currency(code: "CAD"))",
                        value: $store.monthlyBudget,
                        in: 500...20_000,
                        step: 100
                    )
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    var isCurrency = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(isCurrency ? value.formatted(.currency(code: "CAD")) : value.formatted(.number.precision(.fractionLength(0))))
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    DashboardView(store: FinanceStore())
}
