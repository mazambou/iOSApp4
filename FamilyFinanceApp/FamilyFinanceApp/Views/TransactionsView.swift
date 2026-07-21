import SwiftUI

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case income = "Income"
    case expenses = "Expenses"

    var id: String { rawValue }
}

enum TransactionSortOption: String, CaseIterable, Identifiable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case highestAmount = "Highest Amount"
    case lowestAmount = "Lowest Amount"

    var id: String { rawValue }
}

struct TransactionsView: View {
    @Bindable var store: FinanceStore
    @State private var searchText = ""
    @State private var selectedFilter: TransactionFilter = .all
    @State private var sortOption: TransactionSortOption = .newest
    @State private var editingTransaction: FinanceTransaction?
    @State private var transactionToDelete: FinanceTransaction?

    // Applies the segmented Picker filter, Searchable text filter, and toolbar sort option.
    private var filteredTransactions: [FinanceTransaction] {
        let typeFilteredTransactions = store.transactions.filter { transaction in
            switch selectedFilter {
            case .all:
                return true
            case .income:
                return transaction.type == .income
            case .expenses:
                return transaction.type == .expense
            }
        }

        let searchedTransactions: [FinanceTransaction]
        if searchText.isEmpty {
            searchedTransactions = typeFilteredTransactions
        } else {
            searchedTransactions = typeFilteredTransactions.filter { transaction in
                transaction.name.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                transaction.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOption {
        case .newest:
            return searchedTransactions.sorted { $0.date > $1.date }
        case .oldest:
            return searchedTransactions.sorted { $0.date < $1.date }
        case .highestAmount:
            return searchedTransactions.sorted { $0.amount > $1.amount }
        case .lowestAmount:
            return searchedTransactions.sorted { $0.amount < $1.amount }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(TransactionFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Results") {
                    ForEach(filteredTransactions) { transaction in
                        NavigationLink {
                            TransactionDetailView(transaction: transaction)
                        } label: {
                            TransactionRowView(transaction: transaction)
                        }
                        // Swipe actions provide quick edit and delete commands.
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                transactionToDelete = transaction
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
                        // Context menu appears when the user long-presses a transaction.
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
                                transactionToDelete = transaction
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets, from: filteredTransactions)
                    }
                }
            }
            .navigationTitle("Transactions")
            .searchable(text: $searchText, prompt: "Search by name or category")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $sortOption) {
                            ForEach(TransactionSortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .overlay {
                if filteredTransactions.isEmpty {
                    ContentUnavailableView(
                        "No Transactions",
                        systemImage: "tray",
                        description: Text("Add a transaction or change your filters.")
                    )
                }
            }
            .confirmationDialog(
                "Delete this transaction?",
                isPresented: Binding(
                    get: { transactionToDelete != nil },
                    set: { if !$0 { transactionToDelete = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let transactionToDelete {
                        store.delete(transactionToDelete)
                    }
                    transactionToDelete = nil
                }

                Button("Cancel", role: .cancel) {
                    transactionToDelete = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }
            // Reuses the same form as AddTransactionView, but pre-fills it for editing.
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
