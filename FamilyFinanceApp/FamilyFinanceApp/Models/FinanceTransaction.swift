import Foundation

// Represents one income or expense item in the family budget.
struct FinanceTransaction: Identifiable, Hashable {
    let id: UUID
    var name: String
    var amount: Double
    var category: TransactionCategory
    var type: TransactionType
    var date: Date

    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        category: TransactionCategory,
        type: TransactionType,
        date: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
    }
}

// Used by the app to separate money coming in from money going out.
enum TransactionType: String, CaseIterable, Identifiable {
    case income = "Income"
    case expense = "Expense"

    var id: String { rawValue }
}

// Categories used for forms, searching, and the statistics chart.
enum TransactionCategory: String, CaseIterable, Identifiable {
    case groceries = "Groceries"
    case rent = "Rent"
    case transport = "Transport"
    case salary = "Salary"
    case utilities = "Utilities"
    case entertainment = "Entertainment"
    case other = "Other"

    var id: String { rawValue }
}
