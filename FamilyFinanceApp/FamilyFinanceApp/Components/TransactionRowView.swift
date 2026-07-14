import SwiftUI

// Displays a compact row for the transactions list.
struct TransactionRowView: View {
    let transaction: FinanceTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .foregroundStyle(transaction.type == .income ? .green : .red)
                .font(.title3)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.headline)

                Text("\(transaction.category.rawValue) • \(transaction.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(transaction.amount, format: .currency(code: "CAD"))
                .font(.headline)
                .foregroundStyle(transaction.type == .income ? .green : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionRowView(
        transaction: FinanceTransaction(
            name: "Metro Groceries",
            amount: 185.75,
            category: .groceries,
            type: .expense
        )
    )
    .padding()
}
