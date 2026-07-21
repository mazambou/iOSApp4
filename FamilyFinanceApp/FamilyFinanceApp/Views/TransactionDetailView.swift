import SwiftUI

struct TransactionDetailView: View {
    let transaction: FinanceTransaction

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Name", value: transaction.name)
                LabeledContent("Type", value: transaction.type.rawValue)
                LabeledContent("Category", value: transaction.category.rawValue)
            }

            Section("Amount") {
                LabeledContent("Total") {
                    Text(transaction.amount, format: .currency(code: "CAD"))
                        .fontWeight(.semibold)
                        .foregroundStyle(transaction.type == .income ? .green : .primary)
                }
            }

            Section("Date") {
                LabeledContent("Transaction Date", value: transaction.date.formatted(date: .long, time: .omitted))
            }
        }
        .navigationTitle("Transaction Details")
    }
}

#Preview {
    NavigationStack {
        TransactionDetailView(
            transaction: FinanceTransaction(
                name: "Metro Groceries",
                amount: 185.75,
                category: .groceries,
                type: .expense
            )
        )
    }
}
