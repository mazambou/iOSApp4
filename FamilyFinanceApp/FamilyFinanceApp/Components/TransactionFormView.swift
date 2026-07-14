import SwiftUI

struct TransactionFormView: View {
    private let transaction: FinanceTransaction?
    private let onSave: (FinanceTransaction) -> Void

    @State private var name: String
    @State private var amountText: String
    @State private var category: TransactionCategory
    @State private var type: TransactionType
    @State private var date: Date

    init(transaction: FinanceTransaction? = nil, onSave: @escaping (FinanceTransaction) -> Void) {
        self.transaction = transaction
        self.onSave = onSave
        _name = State(initialValue: transaction?.name ?? "")
        _amountText = State(initialValue: transaction.map { String(format: "%.2f", $0.amount) } ?? "")
        _category = State(initialValue: transaction?.category ?? .groceries)
        _type = State(initialValue: transaction?.type ?? .expense)
        _date = State(initialValue: transaction?.date ?? Date())
    }

    private var amount: Double? {
        Double(amountText.replacingOccurrences(of: ",", with: "."))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (amount ?? 0) > 0
    }

    var body: some View {
        Form {
            Section("Transaction") {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)

                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)

                Picker("Type", selection: $type) {
                    ForEach(TransactionType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Details") {
                Picker("Category", selection: $category) {
                    ForEach(TransactionCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }

                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Section {
                Button(transaction == nil ? "Add Transaction" : "Save Changes") {
                    saveTransaction()
                }
                .disabled(!canSave)
            }
        }
    }

    private func saveTransaction() {
        guard let amount else { return }

        let savedTransaction = FinanceTransaction(
            id: transaction?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            category: category,
            type: type,
            date: date
        )

        onSave(savedTransaction)

        if transaction == nil {
            name = ""
            amountText = ""
            category = .groceries
            type = .expense
            date = Date()
        }
    }
}

#Preview {
    TransactionFormView { transaction in
        print(transaction.name)
    }
}
