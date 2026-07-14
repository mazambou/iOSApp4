import SwiftUI

struct TransactionsView: View {
    @Bindable var store: FinanceStore
    @State private var searchText = ""
    @State private var editingTransaction: FinanceTransaction?

    private var filteredTransactions: [FinanceTransaction] {
        let sortedTransactions = store.transactions.sorted { $0.date > $1.date }

        guard !searchText.isEmpty else {
            return sortedTransactions
        }

        return sortedTransactions.filter { transaction in
            transaction.name.localizedCaseInsensitiveContains(searchText) ||
            transaction.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
            transaction.type.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTransactions) { transaction in
                    TransactionRowView(transaction: transaction)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.delete(transaction)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                editingTransaction = transaction
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .contextMenu {
                            Button {
                                editingTransaction = transaction
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button {
                                store.duplicate(transaction)
                            } label: {
                                Label("Duplicate", systemImage: "plus.square.on.square")
                            }

                            Button(role: .destructive) {
                                store.delete(transaction)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete { offsets in
                    store.delete(at: offsets, from: filteredTransactions)
                }
            }
            .navigationTitle("Transactions")
            .searchable(text: $searchText, prompt: "Search by name or category")
            .overlay {
                if filteredTransactions.isEmpty {
                    ContentUnavailableView(
                        "No Transactions",
                        systemImage: "tray",
                        description: Text("Add a transaction or change your search.")
                    )
                }
            }
            .sheet(item: $editingTransaction) { transaction in
                NavigationStack {
                    TransactionFormView(transaction: transaction) { updatedTransaction in
                        store.update(updatedTransaction)
                        editingTransaction = nil
                    }
                    .navigationTitle("Edit Transaction")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                editingTransaction = nil
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TransactionsView(store: FinanceStore())
}
