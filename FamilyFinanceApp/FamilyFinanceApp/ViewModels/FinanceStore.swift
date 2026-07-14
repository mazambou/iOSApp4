import Foundation

@Observable
final class FinanceStore {
    var monthlyBudget: Double = 4_500
    var transactions: [FinanceTransaction] = FinanceStore.sampleTransactions

    var monthlyIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var monthlyExpenses: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Double {
        monthlyBudget - monthlyExpenses
    }

    var budgetUsedRatio: Double {
        guard monthlyBudget > 0 else { return 0 }
        return min(monthlyExpenses / monthlyBudget, 1)
    }

    var expensesByCategory: [(category: TransactionCategory, total: Double)] {
        TransactionCategory.allCases
            .map { category in
                let total = transactions
                    .filter { $0.type == .expense && $0.category == category }
                    .reduce(0) { $0 + $1.amount }
                return (category, total)
            }
            .filter { $0.total > 0 }
    }

    func add(_ transaction: FinanceTransaction) {
        transactions.append(transaction)
    }

    func update(_ transaction: FinanceTransaction) {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
    }

    func delete(_ transaction: FinanceTransaction) {
        transactions.removeAll { $0.id == transaction.id }
    }

    func delete(at offsets: IndexSet, from visibleTransactions: [FinanceTransaction]) {
        let ids = offsets.map { visibleTransactions[$0].id }
        transactions.removeAll { ids.contains($0.id) }
    }

    func duplicate(_ transaction: FinanceTransaction) {
        let copy = FinanceTransaction(
            name: "\(transaction.name) copy",
            amount: transaction.amount,
            category: transaction.category,
            type: transaction.type,
            date: transaction.date
        )
        transactions.append(copy)
    }
}

extension FinanceStore {
    static let sampleTransactions: [FinanceTransaction] = [
        FinanceTransaction(name: "Main Salary", amount: 4200, category: .salary, type: .income),
        FinanceTransaction(name: "Metro Groceries", amount: 185.75, category: .groceries, type: .expense),
        FinanceTransaction(name: "Rent", amount: 1650, category: .rent, type: .expense),
        FinanceTransaction(name: "OPUS Card", amount: 97, category: .transport, type: .expense),
        FinanceTransaction(name: "Hydro-Quebec", amount: 92.40, category: .utilities, type: .expense),
        FinanceTransaction(name: "Family Movie Night", amount: 64, category: .entertainment, type: .expense)
    ]
}
